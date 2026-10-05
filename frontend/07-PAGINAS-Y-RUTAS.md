# 07 · Páginas y rutas (`src/pages/`)

```
src/pages/
├── public/   LandingPage, PublicMapPage
├── auth/     LoginPage, RegisterPage, ForgotPasswordPage, UpdatePasswordPage
├── user/     UserDashboard, UserMapPage, MyReportsPage, NewsPage, ServicesPage,
│             CreateReportPage, ProfilePage, ReportDetailPage
├── admin/    AdminDashboard
└── entity/   EntityLogin, EntityDashboard, EntityDashboardCustom, EntityReportDetail
```

## Tabla de rutas

| Ruta | Página | Acceso | Layout |
|---|---|---|---|
| `/` | `LandingPage` | Público (con sesión redirige a `/user`) | Propio |
| `/map` | `PublicMapPage` | Público | Propio |
| `/login` | `LoginPage` | Público | `AuthLayout` |
| `/register` | `RegisterPage` | Público | `AuthLayout` |
| `/forgot-password` | `ForgotPasswordPage` | Público | `AuthLayout` |
| `/reset-password?token=&email=` | `UpdatePasswordPage` | Público (enlace del correo) | `AuthLayout` |
| `/report/:id` | `ReportDetailPage` | Público | Propio |
| `/user` | `UserDashboard` (Inicio) | Sesión | `UserLayout` |
| `/user/map` | `UserMapPage` | Sesión | `UserLayout` |
| `/user/reports` | `MyReportsPage` | Sesión | `UserLayout` |
| `/user/news` | `NewsPage` | Sesión | `UserLayout` |
| `/user/services` | `ServicesPage` | Sesión | `UserLayout` |
| `/report/new` | `CreateReportPage` | Sesión | `UserLayout` |
| `/profile` | `ProfilePage` | Sesión | `UserLayout` |
| `/admin` | `AdminDashboard` | Rol `administrador` | Propio |
| `/entity/login/:entityId` | `EntityLogin` | Público | Propio |
| `/entity/dashboard` | `EntityDashboard` | Rol `entidad` | Propio |
| `/entity/dashboard/:entityId` | `EntityDashboardCustom` | Rol `entidad` | Propio (datos simulados) |
| `/entity/report/:id` | `EntityReportDetail` | Rol `entidad` | Propio |
| `*` | — | — | Redirige a `/` |

---

## Públicas

### `LandingPage` (`/`)

Página de presentación. No llama a la API.

1. **Encabezado** fijo: logo, enlaces a *Cómo funciona* y *Mapa de reportes*, *Iniciar sesión* y *Crear cuenta* (menú desplegable en el celular).
2. **Portada** con carrusel de fotos de Buenaventura, el eslogan "Tu barrio, en el mapa de Buenaventura", botones *Reportar un problema* y *Ver el mapa de reportes*.
3. **Cómo funciona** (`#como-funciona`): 4 pasos numerados y los tipos de problema que se pueden reportar.
4. **Por qué reportar aquí**: foto, recorrido de estados (Pendiente → En revisión → En proceso → Resuelto) y tres beneficios.
5. **Reseñas** (`ReviewsCarousel`).
6. **Llamado a la acción** y **footer** (`SiteFooter`).

### `PublicMapPage` (`/map`)

Mapa a pantalla completa con todos los reportes visibles (`useReportsData`) y los servicios de la ciudad.

- Panel de filtros *Reportes en Buenaventura* (estado con conteos y tipo de problema): fijo a la derecha en escritorio, detrás del botón *Filtros* en el celular.
- Visitantes: tarjeta "¿Viste algo que no está en el mapa?" con enlace a crear cuenta (se puede cerrar).
- Con sesión: el encabezado muestra *Ir a mi panel*.
- Si la API falla: aviso con *Intentar de nuevo*.

### `ReportDetailPage` (`/report/:id`)

Detalle de un reporte (`getReportById`) con su foto, estado, ubicación, entidad responsable y el **chat de seguimiento** (`getReportMessages`, `createReportMessage`; editar o borrar los mensajes propios durante 5 minutos). Es pública para poder compartir el enlace; el chat solo funciona para el autor, la administración y la entidad asignada.

---

## Autenticación

Las cuatro usan `AuthLayout` y el componente `Input` (con etiquetas accesibles y botón para mostrar la contraseña).

| Página | Qué hace |
|---|---|
| `LoginPage` | `login()` del contexto. Si el correo no está verificado, el toast ofrece *Reenviar correo*. Lee `?verificado=ok\|invalido` (al volver del enlace del correo) y muestra el resultado. Tras entrar, `WelcomeAnimation` y redirección según el rol. |
| `RegisterPage` | `signUp()`. Valida en el formulario que la contraseña tenga 8 caracteres y que ambas coincidan, con el error junto al campo. Al terminar avisa que revise el correo y lleva a `/login`. |
| `ForgotPasswordPage` | `resetPassword(email)`. Luego muestra "Revisa tu correo" con la opción *Usar otro correo*. |
| `UpdatePasswordPage` | Lee `token` y `email` de la URL (si faltan, lleva a `/forgot-password`). `updatePassword()` y, al terminar, vuelve a `/login` a los 3 segundos. |

---

## Panel ciudadano (dentro de `UserLayout`)

### `UserDashboard` · Inicio (`/user`)

Resumen con accesos rápidos:

- Saludo con el nombre y la fecha, y el clima (`WeatherWidget`).
- Bloque *¿Viste algo en tu calle?* con el botón *Reportar un problema*.
- **Mis reportes**: hechos, abiertos y resueltos (`getUserReports` + `summarizeReports`).
- **Mapa de la ciudad**: vista previa no interactiva (para no atrapar el scroll en el celular) con los reportes abiertos y resueltos; al tocarla abre `/user/map`.
- **Tus últimos reportes**: los 4 más recientes con su estado, o un mensaje para hacer el primero.
- Accesos a Noticias, Servicios y Mi perfil, y las 3 últimas noticias (`getPublicNews`).

### `UserMapPage` · Mapa (`/user/map`)

Mapa a pantalla completa (`useReportsData` + `useMapFilters`) con el panel de filtros: *Toda la ciudad / Mis reportes*, estado, tipo de problema y *Mostrar servicios de la ciudad*.

### `MyReportsPage` · Mis reportes (`/user/reports`)

Lista de los reportes propios (`getUserReports`), del más reciente al más antiguo, con pestañas *Todos / Abiertos / Resueltos* y su conteo. Cada fila muestra foto (`ImageWithFallback`), título, categoría, dirección, fecha, apoyos y entidad, y lleva al detalle. Mensaje propio para cada pestaña vacía.

### `NewsPage` · Noticias (`/user/news`)

Todas las noticias publicadas (`getPublicNews`) con búsqueda por título y contenido, y modal de lectura. El botón *Filtrar* todavía no tiene acción asignada.

### `ServicesPage` · Servicios (`/user/services`)

Lista de servicios de la ciudad con buscador y filtro por tipo (`CityServicesFilter`).

### `CreateReportPage` · Nuevo reporte (`/report/new`)

Formulario: título, tipo de incidencia (`IncidentTypeSelector` con `getReportCategories`), descripción, ubicación en el mapa (`LocationPickerMap`), foto opcional y entidad (`getActiveEntities`; si no se elige, la API asigna la de la categoría).

Al enviar: `createReport()` y, si hay foto, `uploadReportImage()` con el id del reporte creado. Luego vuelve a `/user`.

### `ProfilePage` · Mi perfil (`/profile`)

- Avatar (se cambia al tocarlo, `uploadAvatar`), nombre, correo, estado y fecha de registro.
- Estadísticas, sistema de reputación (votos positivos y negativos) e insignias (`getUserBadgesWithDetails`).
- Pestañas *Mis Reportes* (con opción de eliminar, `deleteReport`) y *Notificaciones*.
- *Cerrar sesión*.

---

## Administración

### `AdminDashboard` (`/admin`)

Encabezado blanco con el logo, "Panel administrativo", campana, avatar y nombre del administrador y *Cerrar sesión*. Debajo, pestañas subrayadas:

| Pestaña | Contenido |
|---|---|
| Dashboard | Totales (reportes, pendientes, usuarios, solucionados), reportes por tipo y por estado (Recharts) y reportes recientes. Usa `getAdminStats` y `getPublicReports`. |
| Gestión de Reportes | `ReportsManagement` |
| Moderación de Usuarios | `UsersManagement` |
| Entidades | `EntitiesManagement` |
| Noticias | `NewsManagement` |
| Servicios en Mapa | `ServicesManagement` |

Detalle de cada pestaña en [06-COMPONENTES-POR-MODULO.md](06-COMPONENTES-POR-MODULO.md#admin).

---

## Entidad

### `EntityLogin` (`/entity/login/:entityId`)

Inicio de sesión con la apariencia de una entidad concreta (nombre y colores según `:entityId`: `aseo`, `movilidad`, `acueducto`…). Usa el mismo `login()` y redirige con `homePathForRole`. Las cuentas de entidad también pueden entrar por `/login`.

### `EntityDashboard` (`/entity/dashboard`)

Panel institucional con los colores de la entidad (variables `--entity-primary` a partir de `entidades.color`). Pestañas:

| Pestaña | Contenido |
|---|---|
| Dashboard | Total asignados, pendientes, en proceso y resueltos (`getEntityStats`) y gráficos. |
| Reportes | Reportes asignados (`getEntityReports`) con acceso al detalle. |
| Actividad | Auditoría del panel (`getEntityActivity`). |
| Configuración | Descripción, teléfono, sitio web, color (`updateEntityDetails`) y logo (`uploadEntityLogo`). |

### `EntityReportDetail` (`/entity/report/:id`)

Detalle de un reporte asignado, cambio de estado (`updateReportStatus`) y chat con el ciudadano.

### `EntityDashboardCustom` (`/entity/dashboard/:entityId`)

Versión anterior del panel que muestra **datos simulados** (`generateMockReports`), no los de la API. Ninguna pantalla enlaza a esta ruta. Pendiente: eliminarla o conectarla a la API.
