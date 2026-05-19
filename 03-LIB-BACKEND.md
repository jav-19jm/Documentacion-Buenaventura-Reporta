# 03 — Capa de Servicios Backend (`src/lib/`)

> Toda la comunicación con Supabase se centraliza en esta carpeta. Ninguna página o componente accede directamente al cliente `supabase`; en su lugar, importan funciones de estos módulos.

---

## 📁 Estructura

```
src/lib/
├── auth.ts           # Autenticación y gestión de perfiles
├── reports.ts        # CRUD de reportes, votos, mensajes, noticias
├── admin.ts          # Operaciones administrativas
├── entities.ts       # Lógica específica del dashboard de entidades
├── badges.ts         # Sistema de gamificación / insignias
├── notifications.ts  # CRUD de notificaciones
├── service-types.ts  # Catálogo de tipos de servicios municipales
└── test-connection.ts # Utilidad de diagnóstico de conexión
```

---

## 📄 `auth.ts` — Autenticación

**Importaciones**: `supabase` (cliente), `Perfil` (tipo).

### Funciones

#### `signUp(email, password, fullName)`
| Detalle | Valor |
|---|---|
| **Tabla** | `auth.users` (Auth API) + `perfiles` |
| **Operación** | `supabase.auth.signUp()` + `supabase.from('perfiles').upsert()` |
| **Retorno** | `{ data: AuthData, error: string \| null }` |

**Flujo línea por línea:**
1. Llama a `supabase.auth.signUp()` con `email`, `password` y `options.data.nombre_completo`.
2. Si el registro es exitoso y existe `data.user`, hace `upsert` en la tabla `perfiles` con los campos `id`, `email`, `nombre_completo` y `rol: 'ciudadano'`. Usa `onConflict: 'id'` para evitar duplicados si existe un trigger de DB.
3. Retorna el resultado.

#### `signIn(email, password)`
| Detalle | Valor |
|---|---|
| **API** | `supabase.auth.signInWithPassword()` |
| **Retorno** | `{ data: { user, session }, error }` |

#### `signOut()`
| API | `supabase.auth.signOut()` |
|---|---|

#### `getCurrentUser()`
| API | `supabase.auth.getUser()` |
|---|---|
| **Retorno** | `{ user, error }` |

#### `getSession()`
| API | `supabase.auth.getSession()` |
|---|---|
| **Retorno** | `{ session, error }` |

#### `getUserProfile(userId: string)`
| Detalle | Valor |
|---|---|
| **Tabla** | `perfiles` |
| **Query** | `SELECT * FROM perfiles WHERE id = userId` (`.single()`) |
| **Retorno** | `{ profile: Perfil \| null, error }` |

#### `updateUserProfile(userId, updates: Partial<Perfil>)`
| Detalle | Valor |
|---|---|
| **Tabla** | `perfiles` |
| **Query** | `UPDATE perfiles SET ... WHERE id = userId` |
| **Retorno** | `{ data, error }` |

#### `uploadAvatar(file: File, userId: string)`
| Detalle | Valor |
|---|---|
| **Storage** | Bucket `avatars`, path: `{userId}-{timestamp}.{ext}` |
| **Tabla** | `perfiles` (actualiza `url_avatar`) |
| **Retorno** | `{ url: string \| null, error }` |

**Flujo:**
1. Genera nombre de archivo con userId + timestamp.
2. Sube a bucket `avatars`.
3. Obtiene URL pública.
4. Actualiza `perfiles.url_avatar`.

#### `resetPassword(email: string)`
| API | `supabase.auth.resetPasswordForEmail()` |
|---|---|
| **redirectTo** | `${window.location.origin}/reset-password` |

#### `updatePassword(newPassword: string)`
| API | `supabase.auth.updateUser({ password })` |
|---|---|

#### `onAuthStateChange(callback)`
| API | `supabase.auth.onAuthStateChange()` |
|---|---|
| **Uso** | Hook `useAuth` se suscribe a cambios de sesión |

---

## 📄 `reports.ts` — Reportes

**Importaciones**: `supabase`, `Reporte`, `EstadoReporte`, `PrioridadReporte`, `checkAndGrantBadges`, `createNotification`.

### Funciones CRUD

#### `createReport(reportData)`
| Detalle | Valor |
|---|---|
| **Tablas** | `reportes` (INSERT), `perfiles` (UPDATE reportes_creados) |
| **Badges** | Llama `checkAndGrantBadges(userId)` después de crear |
| **Parámetros** | `{ titulo, descripcion, categoria, direccion_ubicacion, latitud?, longitud?, url_imagen?, prioridad?, id_entidad? }` |

**Flujo detallado:**
1. `supabase.auth.getUser()` → obtiene userId.
2. `INSERT INTO reportes` con `estado: 'pendiente'`, `prioridad: 'media'` por defecto.
3. `SELECT reportes_creados FROM perfiles WHERE id = userId`.
4. `UPDATE perfiles SET reportes_creados = reportes_creados + 1`.
5. `checkAndGrantBadges(userId)` → verifica si desbloquea insignias.

#### `getPublicReports()`
```sql
SELECT *, perfiles:id_usuario(id, nombre_completo, url_avatar),
         entidades:id_entidad(id, nombre, slug, color)
FROM reportes
WHERE visible = true
ORDER BY fecha_creacion DESC
```

#### `getAdminReports()`
Igual que `getPublicReports()` pero **sin filtro** `visible = true` (muestra todo).

#### `getUserReports()`
```sql
SELECT *, entidades:id_entidad(id, nombre, slug, color)
FROM reportes
WHERE id_usuario = {current_user_id}
ORDER BY fecha_creacion DESC
```

#### `getReportById(reportId)`
```sql
SELECT *, perfiles:id_usuario(id, nombre_completo, email, telefono, url_avatar, puntuacion_reputacion),
         entidades:id_entidad(id, nombre, slug, color, email, telefono, descripcion, sitio_web)
FROM reportes WHERE id = reportId
```
> Trae la información completa del perfil y entidad con campos extendidos.

#### `updateReportStatus(reportId, estado)`
| Detalle | Valor |
|---|---|
| **Tablas** | `reportes` (UPDATE), `notificaciones` (INSERT) |
| **Lógica** | Si `estado` es `resuelto` o `cancelado`, pone `visible = false` |
| **Notificación** | Tipo `reporte_resuelto` o `reporte_actualizado` al ciudadano |

#### `deleteReport(reportId)`
Soft-delete: `UPDATE reportes SET visible = false WHERE id = reportId AND id_usuario = current_user`.

#### `voteReport(reportId, tipoVoto)`
**El flujo de votación más complejo:**

1. Obtiene el reporte para saber `id_usuario` (autor).
2. Verifica si el usuario actual ya votó en `votos_reportes`.
3. Si ya votó lo mismo → error. Si cambió de opinión → `UPDATE tipo_voto`.
4. Si es voto nuevo → `INSERT INTO votos_reportes`.
5. Recuenta votos positivos y negativos con `SELECT COUNT(*)`.
6. `UPDATE reportes SET votos_positivos, votos_negativos`.
7. Recalcula reputación del autor: suma todos los votos de todos sus reportes.
8. `UPDATE perfiles SET votos_positivos, votos_negativos, puntuacion_reputacion`.
9. `checkAndGrantBadges(autor_id)`.
10. Si el votante no es el autor → `createNotification` de tipo `mencion`.

#### `uploadReportImage(file, reportId)`
| Storage | Bucket `report-images` |
|---|---|
| Post-upload | `UPDATE reportes SET url_imagen` |

### Funciones de consulta

#### `getReportsByCategory(categoria)`
Filtra reportes por categoría con join a `perfiles`.

#### `getReportsByStatus(estado)`
Filtra reportes por estado con join a `perfiles` y `entidades`.

#### `getReportStats()`
Retorna `{ total, byStatus: {}, byCategory: {} }` contando reportes.

### Mensajería

#### `getReportMessages(reporteId)`
```sql
SELECT *, perfiles:id_remitente(nombre_completo, url_avatar, rol)
FROM mensajes WHERE id_reporte = reporteId
ORDER BY fecha_creacion ASC
```

#### `createReportMessage(reporteId, mensaje, tipoRemitente?)`
**Flujo de notificaciones cruzadas:**
1. Si no se provee `tipoRemitente`, detecta el rol del remitente desde `perfiles`.
2. Inserta el mensaje.
3. **Notifica a todos los admins** de tipo `nuevo_mensaje`.
4. **Notifica al ciudadano** si el remitente no es él.
5. **Notifica a la entidad** responsable buscando usuarios cuyo email coincida con el email de la entidad.

#### `updateReportMessage(mensajeId, nuevoMensaje)`
- Verificación de propiedad (solo el remitente puede editar).
- Límite de 5 minutos desde la creación.

#### `deleteReportMessage(mensajeId)`
- Mismas verificaciones que `updateReportMessage`.
- `DELETE FROM mensajes WHERE id = mensajeId`.

### Noticias (públicas)

#### `getPublicNews()`
```sql
SELECT *, entidades(nombre)
FROM noticias WHERE esta_publicada = true
ORDER BY fecha_creacion DESC
```

#### `getReportCategories()`
```sql
SELECT * FROM categorias_reportes WHERE esta_activa = true ORDER BY nombre ASC
```

---

## 📄 `admin.ts` — Administración

**Importaciones**: `supabase`, `createNotification`, `createReportMessage`.

### Usuarios

| Función | Query | Tabla |
|---|---|---|
| `getAllUsers()` | `SELECT * FROM perfiles ORDER BY fecha_creacion DESC` | `perfiles` |
| `updateUserStatus(userId, estado, motivo?)` | `UPDATE perfiles SET estado, motivo_bloqueo` | `perfiles` |
| `updateUserRole(userId, rol)` | `UPDATE perfiles SET rol` | `perfiles` |

### Entidades CRUD

| Función | Operación |
|---|---|
| `getAllEntities()` | `SELECT * FROM entidades ORDER BY nombre` |
| `createEntity(entity)` | `INSERT INTO entidades` |
| `updateEntity(id, updates)` | `UPDATE entidades SET ...` |
| `deleteEntity(id)` | `DELETE FROM entidades WHERE id` |

### Noticias CRUD

| Función | Operación | Notificación |
|---|---|---|
| `getAllNews()` | `SELECT *, entidades(nombre) FROM noticias` | — |
| `createNews(news)` | `INSERT INTO noticias` | ✅ `alerta_sistema` a todos los ciudadanos |
| `updateNews(id, updates)` | `UPDATE noticias` | — |
| `deleteNews(id)` | `DELETE FROM noticias` | — |
| `togglePublishNews(id, bool)` | `UPDATE noticias SET esta_publicada, fecha_publicacion` | — |
| `uploadNewsImage(file, newsId)` | Upload a bucket `news` + `UPDATE noticias SET url_imagen` | — |

### Reportes (Admin)

| Función | Operación | Notificación |
|---|---|---|
| `assignReportEntity(reportId, id_entidad)` | `UPDATE reportes SET id_entidad` | ✅ Al ciudadano + a la entidad (via email match) |
| `deleteReportAdmin(reportId)` | `UPDATE reportes SET visible = false` | — |
| `addAdminComment(reportId, mensaje)` | Delega a `createReportMessage(id, msg, 'moderador')` | ✅ (heredado) |

### Estadísticas

#### `getAdminStats()`
Retorna:
```typescript
{
  reports: { total, byStatus: {}, byCategory: {} },
  users: { total, byStatus: {} },
  entities: number
}
```

### Servicios CRUD

| Función | Operación | Notificación |
|---|---|---|
| `getAllServices()` | `SELECT * FROM servicios ORDER BY nombre` | — |
| `createService(service)` | `INSERT INTO servicios` | ✅ `alerta_sistema` a ciudadanos |
| `updateService(id, updates)` | `UPDATE servicios` | — |
| `deleteService(id)` | `DELETE FROM servicios` | — |

---

## 📄 `entities.ts` — Dashboard de Entidades

### Funciones

| Función | Query | Descripción |
|---|---|---|
| `getEntityById(entityId)` | `SELECT * FROM entidades WHERE id` | Datos de una entidad |
| `getEntityReports(entityId, category?)` | `SELECT *, perfiles:id_usuario(nombre_completo, email) FROM reportes` | Si hay categoría, usa `OR` para incluir reportes de esa categoría O asignados a la entidad |
| `getEntityReportsByStatus(entityId, estado)` | Filtra por entidad + estado | — |
| `getEntityStats(entityId)` | Conteo por estado de reportes asignados | Retorna `{ total, pendiente, en_revision, en_proceso, resuelto, cancelado }` |
| `getAllEntities()` | `SELECT * FROM entidades ORDER BY nombre` | Duplicado del de admin.ts |
| `updateReportStatus(reportId, estado)` | UPDATE + notificación al ciudadano | Si `resuelto` → incrementa `reportes_resueltos` del autor + `checkAndGrantBadges` |
| `updateEntityDetails(entityId, updates)` | `UPDATE entidades SET ...` | — |
| `uploadEntityLogo(entityId, file)` | Upload a bucket `logos` | — |
| `getEntityActivity(entityId)` | `SELECT * FROM actividad_entidades LIMIT 50` | Registro de auditoría |
| `logEntityActivity(entityId, tipo, titulo, desc)` | `INSERT INTO actividad_entidades` | — |

---

## 📄 `badges.ts` — Gamificación

### Funciones

#### `getAllBadges()`
```sql
SELECT * FROM insignias ORDER BY nombre
```

#### `getUserBadges(userId)`
```sql
SELECT *, insignias(id, nombre, descripcion, icono, requisito_texto)
FROM insignias_usuarios WHERE id_usuario = userId
ORDER BY fecha_obtencion DESC
```

#### `grantBadgeToUser(userId, badgeId)`
1. Verifica si ya la tiene (`SELECT ... WHERE id_usuario AND id_insignia`).
2. Si no → `INSERT INTO insignias_usuarios`.

#### `checkAndGrantBadges(userId)` ⭐
**Motor principal de gamificación.** Se ejecuta automáticamente tras:
- Crear un reporte
- Votar
- Resolver un reporte

**Reglas actuales:**

| Insignia | Condición |
|---|---|
| `Primer Reporte` | `reportes_creados >= 1` |
| `10 Reportes` | `reportes_creados >= 10` |
| `50 Reportes` | `reportes_creados >= 50` |
| `Solucionador` | `reportes_resueltos >= 1` |
| `Embajador` | `puntuacion_reputacion >= 100` |

#### `getUserBadgesWithDetails(userId)`
Igual que `getUserBadges` pero transforma la estructura anidada a un array plano:
```typescript
// Output: [{ id, fecha_obtencion, nombre, icono, requisito_texto, ... }]
```

---

## 📄 `notifications.ts` — Notificaciones

| Función | Operación |
|---|---|
| `getUserNotifications(userId)` | `SELECT * FROM notificaciones WHERE id_usuario ORDER BY fecha_creacion DESC` |
| `deleteNotification(id)` | `DELETE FROM notificaciones WHERE id` |
| `markNotificationAsRead(id)` | `UPDATE notificaciones SET esta_leida = true` |
| `createNotification({ id_usuario, id_reporte?, tipo, titulo, mensaje })` | `INSERT INTO notificaciones` |

---

## 📄 `service-types.ts` — Catálogo de servicios

Exporta un array constante `SERVICE_TYPES` y una función `getServiceTypeConfig(typeId)`:

```typescript
const SERVICE_TYPES = [
  { id: "salud",          label: "Salud",          icon: Hospital,  color: "red" },
  { id: "seguridad",      label: "Seguridad",      icon: Shield,    color: "blue" },
  { id: "educacion",      label: "Educación",      icon: School,    color: "yellow" },
  { id: "transporte",     label: "Transporte",     icon: Bus,       color: "orange" },
  { id: "recreacion",     label: "Recreación",     icon: TreePalm,  color: "green" },
  { id: "administrativo", label: "Administrativo", icon: Building2, color: "purple" },
  { id: "otro",           label: "Otro",           icon: Info,      color: "gray" },
];
```

---

## 📄 `test-connection.ts` — Diagnóstico

Prueba la conexión a Supabase consultando la tabla `entities`. Se auto-ejecuta con `setTimeout` 1 segundo después del import.

---

## 🪝 `src/hooks/useAuth.ts` — Hook de Autenticación

**Hook React global** que provee estado de autenticación a toda la app.

### Estado retornado

```typescript
{
  user: any,                    // Objeto auth de Supabase
  profile: Perfil | null,       // Datos de la tabla perfiles
  session: any,                 // Sesión JWT
  loading: boolean,             // true mientras carga
  isAuthenticated: boolean,     // !!user
  isAdmin: boolean,             // profile.rol === 'administrador'
  isEntity: boolean,            // profile.rol === 'entidad'
  isCitizen: boolean,           // profile.rol === 'ciudadano'
}
```

### Flujo interno

1. Al montar: llama `getSession()` → si hay sesión, carga `fetchProfile(userId)`.
2. Se suscribe a `onAuthStateChange` para detectar login/logout en tiempo real.
3. **Seguridad**: Si el perfil tiene `estado !== 'activo'` (bloqueado/suspendido):
   - Muestra toast con motivo de bloqueo.
   - Fuerza `signOut()` automáticamente.
   - Limpia todo el estado local.
4. Al desmontar: cancela la suscripción.
