# 08 — Páginas de la Aplicación (`pages/`)

## 📁 Estructura

```
src/app/pages/
├── LandingPage.tsx         # Página de aterrizaje pública
├── LoginPage.tsx           # Inicio de sesión
├── RegisterPage.tsx        # Registro de ciudadano
├── ForgotPasswordPage.tsx  # Recuperar contraseña
├── UpdatePasswordPage.tsx  # Cambiar contraseña (post-email)
├── PublicMapPage.tsx       # Mapa público de reportes
├── admin/
│   ├── AdminDashboard.tsx      # Panel principal del administrador
│   ├── ReportsManagement.tsx   # CRUD de reportes (admin)
│   ├── UsersManagement.tsx     # Moderación de usuarios
│   ├── EntitiesManagement.tsx  # CRUD de entidades
│   ├── NewsManagement.tsx      # CRUD de noticias
│   └── ServicesManagement.tsx  # CRUD de servicios municipales
├── entity/
│   ├── EntitySelection.tsx     # Selección de entidad para login
│   ├── EntityLogin.tsx         # Login de entidad
│   ├── EntityDashboard.tsx     # Dashboard de entidad
│   ├── EntityDashboardCustom.tsx # Dashboard con entityId en URL
│   └── EntityReportDetail.tsx  # Detalle de reporte para entidad
└── user/
    ├── UserDashboard.tsx       # Dashboard del ciudadano
    ├── CreateReportPage.tsx    # Crear nuevo reporte
    ├── ReportDetailPage.tsx    # Detalle + chat de reporte
    ├── ProfilePage.tsx         # Perfil del ciudadano
    └── NewsPage.tsx            # Noticias para el ciudadano
```

---

## 🌐 Páginas Públicas

### `LandingPage.tsx` (20.2 KB)

Página de bienvenida con diseño premium. Secciones:
1. Hero con gradiente amarillo→verde y CTA.
2. Estadísticas animadas.
3. Sección "¿Cómo funciona?" (3 pasos).
4. Categorías de reportes.
5. Carrusel de testimonios (`ReviewsCarousel`).
6. Footer.

**No consume funciones de `src/lib/`** — es puramente presentacional.

---

### `LoginPage.tsx` (7.5 KB)

**Funciones de `src/lib/` usadas:**
| Función | Archivo | Uso |
|---|---|---|
| `signIn(email, password)` | `auth.ts` | Autenticación con Supabase Auth |
| `getUserProfile(userId)` | `auth.ts` | Obtiene perfil para determinar rol |

**Flujo detallado:**
1. El usuario ingresa email + password.
2. Llama `signIn()` → obtiene `data.user`.
3. Llama `getUserProfile(data.user.id)` → obtiene `profile`.
4. Según `profile.rol`:
   - `administrador` → `navigate('/admin')`
   - `entidad` → `navigate('/entity/dashboard')`
   - otro → Muestra `WelcomeAnimation`, luego `navigate('/user')`
5. Si `profile.estado !== 'activo'` → `useAuth` cierra sesión automáticamente.

**Componentes usados:** `Input`, `Button`, `WelcomeAnimation`.

---

### `RegisterPage.tsx` (5.5 KB)

**Funciones de `src/lib/` usadas:**
| Función | Archivo |
|---|---|
| `signUp(email, password, fullName)` | `auth.ts` |

**Flujo:** Formulario → `signUp()` → toast de confirmación → redirige a `/login`.

---

### `ForgotPasswordPage.tsx` (4.1 KB)

**Funciones de `src/lib/` usadas:**
| Función | Archivo |
|---|---|
| `resetPassword(email)` | `auth.ts` |

**Flujo:** Email → `resetPassword()` → envía email con link a `/reset-password`.

---

### `UpdatePasswordPage.tsx` (5.1 KB)

**Funciones de `src/lib/` usadas:**
| Función | Archivo |
|---|---|
| `updatePassword(newPassword)` | `auth.ts` |

**Flujo:** El usuario llega via link del email → ingresa nueva contraseña → `updatePassword()` → redirige a `/login`.

---

### `PublicMapPage.tsx` (6.8 KB)

**Funciones de `src/lib/` usadas:**
| Función | Archivo |
|---|---|
| `getPublicReports()` | `reports.ts` |

Renderiza `ReportsMap` con todos los reportes visibles. Sin necesidad de autenticación.

---

## 👤 Páginas de Usuario (`pages/user/`)

### `UserDashboard.tsx` (15.1 KB)

**Funciones de `src/lib/` usadas:**
| Función | Archivo | Contexto |
|---|---|---|
| `getPublicReports()` | `reports.ts` | Carga reportes para el mapa |
| `getReportCategories()` | `reports.ts` | Carga categorías dinámicas de Supabase |

**Componentes funcionales integrados:**
- `ReportsMap` — Mapa interactivo principal
- `NotificationBell` — Campana de notificaciones
- `WeatherWidget` — Clima de Buenaventura
- `NewsSection` — Panel expandible de noticias
- `CityServicesFilter` — Filtro de servicios municipales
- `Card`, `Badge`, `Button` — UI primitivos

**Características:**
- Filtro de mapa: "Todos" vs "Mis Reportes" (compara `id_usuario` con usuario actual).
- Dropdown de categorías dinámico (cargado de `categorias_reportes`).
- Sidebar con lista de reportes recientes del usuario.
- FAB (Floating Action Button) para crear reporte → `/report/new`.
- Guard de autenticación: redirige a `/login` si no autenticado.

---

### `CreateReportPage.tsx` (13.2 KB)

**Funciones de `src/lib/` usadas:**
| Función | Archivo | Paso |
|---|---|---|
| `getReportCategories()` | `reports.ts` | Carga tipos de incidencia |
| `getAllEntities()` | `admin.ts` | Carga lista de entidades para selector |
| `createReport(reportData)` | `reports.ts` | Envía reporte a DB |
| `uploadReportImage(file, reportId)` | `reports.ts` | Sube foto evidencia |

**Flujo completo del formulario (6 pasos):**
1. **Título** (max 100 chars) → `Input`
2. **Tipo de incidencia** → `IncidentTypeSelector` (categorías de `categorias_reportes`)
3. **Entidad destino** (opcional) → `<select>` con entidades de Supabase
4. **Descripción** → `Textarea`
5. **Evidencia** (opcional) → Upload de imagen con preview
6. **Ubicación** → `LocationPickerMap` (click para colocar marker)

**Al enviar:**
```
createReport({ titulo, descripcion, categoria, id_entidad, direccion_ubicacion, latitud, longitud })
  → Si hay imagen: uploadReportImage(imageFile, report.id)
    → toast.success → navigate('/user')
```

---

### `ReportDetailPage.tsx` (22.4 KB)

**Funciones de `src/lib/` usadas:**
| Función | Archivo |
|---|---|
| `getReportById(reportId)` | `reports.ts` |
| `getReportMessages(reporteId)` | `reports.ts` |
| `createReportMessage(reporteId, mensaje)` | `reports.ts` |
| `updateReportMessage(mensajeId, nuevoMensaje)` | `reports.ts` |
| `deleteReportMessage(mensajeId)` | `reports.ts` |
| `voteReport(reportId, tipoVoto)` | `reports.ts` |
| `getUserBadgesWithDetails(userId)` | `badges.ts` |

**Características:**
- Vista completa del reporte (imagen, mapa, estado, prioridad).
- Chat en tiempo real (Supabase Realtime en `mensajes`).
- Votos positivos/negativos.
- Historial de cambios de estado.
- Editar/eliminar mensajes propios (ventana de 5 minutos).

---

### `ProfilePage.tsx` (22.3 KB)

**Funciones de `src/lib/` usadas:**
| Función | Archivo |
|---|---|
| `getUserProfile(userId)` | `auth.ts` |
| `updateUserProfile(userId, updates)` | `auth.ts` |
| `uploadAvatar(file, userId)` | `auth.ts` |
| `getUserReports()` | `reports.ts` |
| `getUserBadgesWithDetails(userId)` | `badges.ts` |
| `signOut()` | `auth.ts` |

**Secciones:**
1. Foto de perfil editable (upload a `avatars` bucket).
2. Información personal editable.
3. Estadísticas (reportes, resueltos, reputación).
4. Insignias desbloqueadas.
5. Lista de reportes del usuario.
6. Botón de cerrar sesión con `LogoutAnimation`.

---

### `NewsPage.tsx` (11.3 KB)

**Funciones de `src/lib/` usadas:**
| Función | Archivo |
|---|---|
| `getPublicNews()` | `reports.ts` |

Grid de noticias publicadas con filtros de categoría y búsqueda.

---

## 🏢 Páginas de Entidad (`pages/entity/`)

### `EntityDashboard.tsx` (33.7 KB)

**Funciones de `src/lib/` usadas:**
| Función | Archivo |
|---|---|
| `getEntityById(entityId)` | `entities.ts` |
| `getEntityReports(entityId, category?)` | `entities.ts` |
| `getEntityStats(entityId)` | `entities.ts` |
| `getAllEntities()` | `entities.ts` |
| `updateEntityDetails(entityId, updates)` | `entities.ts` |
| `uploadEntityLogo(entityId, file)` | `entities.ts` |
| `getEntityActivity(entityId)` | `entities.ts` |
| `logEntityActivity(...)` | `entities.ts` |
| `signOut()` | `auth.ts` |

**Tabs:** Dashboard (estadísticas + tabla de reportes), Actividad (auditoría), Configuración (logo, sitio web, color).

**Lógica de vinculación entidad-usuario:**
1. Busca `profile.id_entidad` → `getEntityById()`.
2. **Fallback**: si no hay `id_entidad`, busca en `getAllEntities()` una entidad cuyo `email` coincida con `profile.email`.
3. Inyecta CSS variables dinámicas (`--entity-primary`, `--entity-bg-light`) según el color de la entidad.

---

### `EntityReportDetail.tsx` (17.7 KB)

**Funciones de `src/lib/` usadas:**
| Función | Archivo |
|---|---|
| `getReportById(reportId)` | `reports.ts` |
| `getReportMessages(reporteId)` | `reports.ts` |
| `createReportMessage(reporteId, mensaje, 'entidad')` | `reports.ts` |
| `updateReportStatus(reportId, estado)` | `entities.ts` |
| `logEntityActivity(...)` | `entities.ts` |

**Características:**
- Detalle del reporte con mapa de ubicación.
- Panel de cambio de estado con selector (pendiente → en_revision → en_proceso → resuelto → cancelado).
- Chat bidireccional con ciudadano (mensajes tipo `'entidad'`).
- Registro automático de actividad al cambiar estado.

---

### `EntitySelection.tsx` / `EntityLogin.tsx` / `EntityDashboardCustom.tsx`

Páginas auxiliares para el flujo de login de entidad:
1. `EntitySelection` — Grid de entidades disponibles.
2. `EntityLogin` — Login con email/password para la entidad seleccionada.
3. `EntityDashboardCustom` — Dashboard con `entityId` en la URL (acceso directo).

---

## ⚙️ Páginas de Administrador (`pages/admin/`)

### `AdminDashboard.tsx` (14.8 KB)

**Funciones de `src/lib/` usadas:**
| Función | Archivo |
|---|---|
| `getAdminStats()` | `admin.ts` |
| `getPublicReports()` | `reports.ts` |
| `signOut()` | `auth.ts` |

**Tabs del panel:** Dashboard (gráficas Recharts), Reportes, Usuarios, Entidades, Noticias, Servicios.

**Guard de acceso:** Si `useAuth().isAdmin === false` → toast error + redirige a `/login`.

---

### `ReportsManagement.tsx` (27.5 KB)

**Funciones de `src/lib/` usadas:**
| Función | Archivo |
|---|---|
| `getAdminReports()` | `reports.ts` |
| `updateReportStatus(reportId, estado)` | `reports.ts` |
| `assignReportEntity(reportId, entityId)` | `admin.ts` |
| `deleteReportAdmin(reportId)` | `admin.ts` |
| `addAdminComment(reportId, mensaje)` | `admin.ts` |
| `getReportMessages(reportId)` | `reports.ts` |
| `getAllEntities()` | `admin.ts` |

**Chat en tiempo real:** Suscripción Realtime a `mensajes` para ver mensajes nuevos sin recargar.

---

### `UsersManagement.tsx` (27.1 KB)

**Funciones de `src/lib/` usadas:**
| Función | Archivo |
|---|---|
| `getAllUsers()` | `admin.ts` |
| `updateUserStatus(userId, estado, motivo)` | `admin.ts` |

**Características:**
- Tabla con todos los usuarios (todos los roles).
- Filtros: búsqueda por nombre/email, estado, **rol** (ciudadano/entidad/moderador/administrador).
- Columna de "Rol" con badges de color.
- Modal de detalle con estadísticas, insignias e historial.
- Acciones: bloquear, suspender, reactivar (con motivo obligatorio).

---

### `EntitiesManagement.tsx` (22.7 KB)

**Funciones de `src/lib/` usadas:**
| Función | Archivo |
|---|---|
| `getAllEntities()` | `admin.ts` |
| `createEntity(entity)` | `admin.ts` |
| `updateEntity(id, updates)` | `admin.ts` |
| `deleteEntity(id)` | `admin.ts` |

CRUD completo de entidades con formulario de creación que incluye generación de contraseña para el usuario de la entidad.

---

### `NewsManagement.tsx` (23.8 KB)

**Funciones de `src/lib/` usadas:**
| Función | Archivo |
|---|---|
| `getAllNews()` | `admin.ts` |
| `createNews(news)` | `admin.ts` |
| `updateNews(id, updates)` | `admin.ts` |
| `deleteNews(id)` | `admin.ts` |
| `togglePublishNews(id, bool)` | `admin.ts` |
| `uploadNewsImage(file, newsId)` | `admin.ts` |

---

### `ServicesManagement.tsx` (16.9 KB)

**Funciones de `src/lib/` usadas:**
| Función | Archivo |
|---|---|
| `getAllServices()` | `admin.ts` |
| `createService(service)` | `admin.ts` |
| `updateService(id, updates)` | `admin.ts` |
| `deleteService(id)` | `admin.ts` |
| `SERVICE_TYPES` | `service-types.ts` |

CRUD de puntos de servicio municipal con selector de tipo y mapa para ubicación.
