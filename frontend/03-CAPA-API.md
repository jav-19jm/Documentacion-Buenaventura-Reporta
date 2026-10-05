# 03 · Capa API, contexto, hooks y utilidades

Toda la comunicación con el backend pasa por `src/api/`. **Ninguna página ni componente usa Axios directamente**: importan funciones de estos módulos.

```
src/
├── api/
│   ├── client.ts          # Instancia de Axios, token, renovación y formato { data, error }
│   ├── auth.ts            # Registro, login, verificación, contraseña, perfil, avatar
│   ├── reports.ts         # Reportes, votos, imágenes, chat, categorías, noticias públicas
│   ├── catalog.ts         # Entidades y servicios públicos
│   ├── notifications.ts   # Notificaciones y denuncias
│   ├── badges.ts          # Insignias de un usuario
│   ├── admin.ts           # Panel de administración
│   └── entities.ts        # Panel de entidad
├── context/AuthContext.tsx
├── hooks/                 # useAuth, useReportsData, useMapFilters
└── lib/                   # utils.ts, report-status.ts, service-types.ts
```

---

## `api/client.ts`

| Exporta | Descripción |
|---|---|
| `api` | Instancia de Axios con `baseURL = VITE_API_URL` y `Accept: application/json`. |
| `getToken()` / `setToken(token)` | Leen y escriben el JWT en `localStorage` (`br_auth_token`), protegidos con `try/catch` (modo privado). |
| `AUTH_EXPIRED_EVENT` | Nombre del evento (`auth:expired`) que se emite cuando la sesión deja de ser válida. |
| `toResult(promesa)` | Convierte una petición en `{ data, error, code? }`. **Nunca lanza.** |
| `getErrorMessage(error)` | Mensaje legible: sin conexión, primer error de validación (422) o `message` del backend. |
| `ApiResult<T>` | `{ data: T \| null; error: string \| null; code?: string }`. `code` es el campo `codigo` del backend (por ejemplo `correo_no_verificado`). |

**Interceptores:**

- *Petición*: agrega `Authorization: Bearer <token>` si hay sesión.
- *Respuesta*: ante un 401 renueva el token una vez (`POST /auth/refresh`) y repite la petición; si no puede, o si llega `403 cuenta_inactiva`, cierra la sesión con `auth:expired`. Detalle en [02-INFRAESTRUCTURA.md](02-INFRAESTRUCTURA.md#sesión).

### Patrón de uso

```ts
const { data, error } = await getUserReports();
if (error) {
  toast.error("No pudimos cargar tus reportes. Revisa tu conexión e inténtalo de nuevo.");
  return;
}
setReports(data ?? []);
```

### Agregar una función

1. Ubícala en el módulo del recurso (o crea uno nuevo en `src/api/`).
2. Documenta el endpoint en un comentario de una línea, como el resto del archivo.
3. Envuelve la llamada con `toResult` y tipa la respuesta:

```ts
/** GET /reports/{id}/history — historial de cambios del reporte */
export async function getReportHistory(reportId: string): Promise<ApiResult<HistorialReporte[]>> {
  return toResult(api.get(`/reports/${reportId}/history`));
}
```

---

## Funciones por módulo

### `auth.ts`

| Función | Endpoint |
|---|---|
| `signUp(email, password, fullName)` | `POST /auth/register` |
| `signIn(email, password)` | `POST /auth/login` |
| `signOut()` | `POST /auth/logout` (el token local se borra siempre) |
| `getMe()` | `GET /auth/me` |
| `resendVerificationEmail(email)` | `POST /auth/email/resend` |
| `resetPassword(email)` | `POST /auth/forgot-password` |
| `updatePassword(token, email, newPassword)` | `POST /auth/reset-password` |
| `getUserProfile(userId)` | `GET /users/{id}` |
| `uploadAvatar(file, userId)` | `POST /users/me/avatar` (multipart) |

### `reports.ts`

| Función | Endpoint |
|---|---|
| `getPublicReports()` | `GET /reports` |
| `getReportById(id)` | `GET /reports/{id}` |
| `getUserReports()` | `GET /users/me/reports` |
| `createReport(datos)` | `POST /reports` (sin `id_entidad`, el backend asigna la de la categoría) |
| `uploadReportImage(file, reportId)` | `POST /reports/{id}/image` (multipart) |
| `deleteReport(id)` | `DELETE /reports/{id}` (borrado lógico) |
| `updateReportStatus(id, estado)` | `PATCH /reports/{id}/status` |
| `voteReport(id, tipoVoto)` | `POST /reports/{id}/votes` |
| `getReportMessages(id)` | `GET /reports/{id}/messages` |
| `createReportMessage(id, mensaje)` | `POST /reports/{id}/messages` |
| `updateReportMessage(id, mensaje)` | `PATCH /messages/{id}` |
| `deleteReportMessage(id)` | `DELETE /messages/{id}` |
| `getReportCategories()` | `GET /report-categories` |
| `getPublicNews()` | `GET /news` |
| `getAdminReports()` | `GET /admin/reports` |

### `catalog.ts`, `notifications.ts`, `badges.ts`

| Función | Endpoint |
|---|---|
| `getActiveEntities()` | `GET /entities` |
| `getActiveServices()` | `GET /services` |
| `getUserNotifications(userId)` | `GET /users/me/notifications` |
| `markNotificationAsRead(id)` | `PATCH /notifications/{id}/read` |
| `deleteNotification(id)` | `DELETE /notifications/{id}` |
| `reportUserToAdmins(userId, reportId, motivo)` | `POST /users/{id}/report-abuse` |
| `getUserBadgesWithDetails(userId)` | `GET /users/{id}/badges` |

### `admin.ts`

| Función | Endpoint |
|---|---|
| `getAdminStats()` | `GET /admin/stats` |
| `getAllUsers()` | `GET /admin/users` |
| `updateUserStatus(id, estado, motivo?)` | `PATCH /admin/users/{id}/status` |
| `updateUserRole(id, rol)` | `PATCH /admin/users/{id}/role` |
| `assignReportEntity(reportId, idEntidad)` | `PATCH /admin/reports/{id}/entity` |
| `deleteReportAdmin(reportId)` | `DELETE /admin/reports/{id}` |
| `addAdminComment(reportId, mensaje)` | `POST /reports/{id}/messages` |
| `getAllEntities()` / `createEntity()` / `updateEntity()` / `deleteEntity()` | `GET` / `POST /admin/entities`, `PUT` / `DELETE /admin/entities/{id}` |
| `getAllNews()` / `createNews()` / `updateNews()` / `deleteNews()` | `GET` / `POST /admin/news`, `PUT` / `DELETE /admin/news/{id}` |
| `togglePublishNews(id, publicada)` | `PATCH /admin/news/{id}/publish` |
| `uploadNewsImage(file, newsId)` | `POST /admin/news/{id}/image` |
| `getAllServices()` / `createService()` / `updateService()` / `deleteService()` | `GET` / `POST /admin/services`, `PUT` / `DELETE /admin/services/{id}` |

### `entities.ts`

| Función | Endpoint |
|---|---|
| `getMyEntity()` | `GET /entity` |
| `updateEntityDetails(cambios)` | `PUT /entity` |
| `uploadEntityLogo(file)` | `POST /entity/logo` |
| `getEntityReports()` | `GET /entity/reports` |
| `getEntityStats()` | `GET /entity/stats` |
| `getEntityActivity()` | `GET /entity/activity` |
| `updateReportStatus(id, estado)` | `PATCH /reports/{id}/status` |

---

## `context/AuthContext.tsx`

Provee la sesión a toda la app. Se consume con `useAuth()` (`hooks/useAuth.ts`), que lanza un error si se usa fuera de `<AuthProvider>`.

| Valor | Tipo | Descripción |
|---|---|---|
| `profile` (alias `user`) | `Perfil \| null` | Usuario autenticado. |
| `loading` | `boolean` | `true` mientras se restaura la sesión al cargar. |
| `isAuthenticated` | `boolean` | Hay perfil. |
| `isAdmin` / `isEntity` / `isCitizen` | `boolean` | Atajos por rol. |
| `login(email, password)` | `Promise<{ profile, error, code? }>` | Inicia sesión y guarda el token. |
| `logout()` | `Promise<void>` | Cierra la sesión en la API y localmente. |
| `refreshProfile()` | `Promise<void>` | Vuelve a pedir `GET /auth/me` (por ejemplo, tras cambiar el avatar). |

---

## Hooks

| Hook | Archivo | Devuelve | Lo usan |
|---|---|---|---|
| `useAuth()` | `hooks/useAuth.ts` | El contexto de sesión | Casi todas las páginas |
| `useReportsData()` | `hooks/useReportsData.ts` | `{ reports, categories, loading, error, refresh }`: reportes públicos y nombres de categoría | Inicio y Mapa del panel, mapa público |
| `useMapFilters(reports)` | `hooks/useMapFilters.ts` | `{ status, setStatus, category, setCategory, counts, visible, activeCount }` | Mapa del panel y mapa público |

`useMapFilters` aplica primero la categoría y luego el estado, de modo que `counts` refleja cuántos reportes hay en cada grupo de estado con la categoría elegida. `activeCount` alimenta el número del botón "Filtros" en el celular.

---

## Utilidades (`src/lib`)

### `utils.ts`

`cn(...clases)`: combina clases con `clsx` y resuelve conflictos de Tailwind con `tailwind-merge` (la última gana).

### `report-status.ts`

Fuente única de etiquetas y colores de los estados de reporte.

| Exporta | Descripción |
|---|---|
| `REPORT_STATUS` | `{ pendiente: { label: "Pendiente", variant: "warning" }, en_revision: …, en_proceso: …, resuelto: …, cancelado: … }` |
| `getReportStatus(estado)` | Etiqueta y variante de `Badge`; para valores desconocidos devuelve "Sin estado". |
| `OPEN_STATUSES` | `pendiente`, `en_revision`, `en_proceso` (reportes abiertos). |
| `summarizeReports(reports)` | `{ total, open, resolved }`. |
| `filterReports(reports, { category, status })` | Filtra por categoría (`null` = todas) y por grupo `todos` / `abiertos` / `resueltos`. |
| `StatusFilter` | `"todos" \| "abiertos" \| "resueltos"`. |

```tsx
const status = getReportStatus(report.estado);
<Badge variant={status.variant}>{status.label}</Badge>
```

### `service-types.ts`

`SERVICE_TYPES`: tipos de servicio del mapa (`salud`, `seguridad`, `educacion`, `transporte`, `recreacion`, `administrativo`, `otro`) con etiqueta, ícono de Lucide y color. `getServiceTypeConfig(tipo)` devuelve la configuración o la de "Otro".

> Pendiente conocido: `CityServicesFilter` arma clases como `` `text-${color}-600` `` a partir de este archivo. Tailwind no genera clases construidas dinámicamente, así que esos íconos salen sin color. Conviene guardar en `SERVICE_TYPES` la clase completa (`"text-red-600"`).
