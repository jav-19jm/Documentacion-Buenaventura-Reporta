# 05 · Componentes comunes (`components/common/`)

Componentes que se usan en varias zonas de la app (público, panel ciudadano, administración y entidad).

```
src/components/common/
├── BrandLogo.tsx            # Logo de la marca (completo o isotipo, color o blanco)
├── ImageWithFallback.tsx    # <img> que muestra un reemplazo si la imagen falla
├── ReportsMap.tsx           # Mapa de reportes y servicios (Leaflet)
├── LocationPickerMap.tsx    # Mapa para elegir la ubicación de un reporte
├── MapFilterPanel.tsx       # Panel de filtros de los mapas
├── MapFiltersToggle.tsx     # Botón "Filtros" de los mapas en celular
├── NotificationBell.tsx     # Campana de notificaciones
├── ProtectedRoute.tsx       # Protección de rutas por sesión y rol
└── animations/
    ├── WelcomeAnimation.tsx # Bienvenida tras iniciar sesión
    └── LogoutAnimation.tsx  # Despedida al cerrar sesión
```

---

## `BrandLogo`

Única forma de mostrar el logo en la interfaz.

```tsx
<BrandLogo />                                  // logo completo a color, 40 px de alto
<BrandLogo variant="mark" className="h-9" />   // solo el isotipo
<BrandLogo tone="white" className="h-12" />    // versión para fondos oscuros
```

| Prop | Valores | Por defecto |
|---|---|---|
| `variant` | `full` (isotipo + nombre), `mark` (solo isotipo) | `full` |
| `tone` | `color` (fondos claros), `white` (fondos oscuros o de marca) | `color` |
| `className` | Controla el tamaño con la altura (`h-10`, `h-12`…); el ancho es automático | `h-10` |

El texto alternativo es siempre "Buenaventura Reporta". Cuando el logo está dentro de un enlace, pon un `aria-label` descriptivo en el enlace (por ejemplo "Buenaventura Reporta, inicio").

## `ImageWithFallback`

Mismas props que `<img>`. Si la imagen no carga (URL rota, archivo borrado, falta `storage:link` en el backend), muestra un ícono gris de imagen en el mismo espacio.

---

## `ReportsMap`

Mapa de OpenStreetMap centrado en Buenaventura (`3.8801, -77.0311`, zoom 13). Ocupa el 100 % de su contenedor, así que el padre debe tener altura definida.

```tsx
<div className="h-80">
  <ReportsMap reports={reportes} onVote={recargar} showServices={false} />
</div>
```

| Prop | Tipo | Descripción |
|---|---|---|
| `reports` | `Reporte[]` | Reportes a mostrar (los que no tienen coordenadas se omiten). Filtra antes de pasarlos. |
| `onVote` | `() => void` | Se llama después de votar, para recargar los datos. |
| `showServices` | `boolean` (por defecto `true`) | Muestra también los servicios de la ciudad (`GET /services`) con su ícono por tipo. |

Al tocar un reporte se abre un *popup* con foto, categoría, estado (`getReportStatus`), descripción, votos (👍 / 👎, requiere sesión) y enlace al detalle. Desde el popup se puede abrir el **perfil del autor** en un modal (estadísticas, insignias) y **denunciarlo** ante la administración (`POST /users/{id}/report-abuse`).

## `LocationPickerMap`

Mapa pequeño para el formulario de nuevo reporte.

| Prop | Tipo | Descripción |
|---|---|---|
| `position` | `{ lat, lng }` | Posición actual del marcador. |
| `onLocationSelect` | `(lat, lng) => void` | Se llama al hacer clic en el mapa. |

## `MapFilterPanel`

Panel de filtros compartido por el mapa del panel ciudadano y el mapa público. Se combina con el hook [`useMapFilters`](03-CAPA-API.md#hooks).

```tsx
const filtros = useMapFilters(reports);

<MapFilterPanel
  categories={categories}
  category={filtros.category}
  onCategoryChange={filtros.setCategory}
  status={filtros.status}
  onStatusChange={filtros.setStatus}
  counts={filtros.counts}
/>
```

| Prop | Descripción |
|---|---|
| `categories`, `category`, `onCategoryChange` | Tipo de problema. Usa un `<select>` nativo (en el celular abre el selector del sistema). `null` = todos. |
| `status`, `onStatusChange`, `counts` | Botones *Todos / Abiertos / Resueltos* con el número de reportes de cada grupo. |
| `scope`, `onScopeChange` | Opcional. Selector *Toda la ciudad / Mis reportes* (solo en el panel ciudadano). |
| `header` | Opcional. Contenido arriba de los filtros (título del mapa público). |
| `children` | Opcional. Controles extra al final (por ejemplo, "Mostrar servicios de la ciudad"). |

## `MapFiltersToggle`

Botón flotante "Filtros" que abre y cierra el panel en pantallas menores a 1024 px (en escritorio el panel siempre está visible). Muestra cuántos filtros hay activos. Props: `open`, `onToggle`, `activeCount`, `controls` (id del panel, para `aria-controls`).

---

## `NotificationBell`

Campana con contador de no leídas y lista desplegable.

- Consulta `GET /users/me/notifications` al montarse y **cada 30 segundos**.
- Reproduce `public/notification.mp3` cuando llega una notificación nueva.
- Permite marcar como leída y borrar cada notificación.
- El color del ícono depende del tipo (`reporte_resuelto`, `alerta_sistema`…).

Se usa en la barra superior del panel ciudadano y del panel de administración.

## `ProtectedRoute`

Componente de ruta (renderiza `<Outlet />`) que protege un grupo de rutas en `routes.tsx`.

```tsx
{ element: <ProtectedRoute roles={["administrador"]} />, children: [...] }
```

| Situación | Resultado |
|---|---|
| Restaurando la sesión | Indicador de carga |
| Sin sesión | Redirige a `/login` |
| Rol no incluido en `roles` | Redirige al panel de su rol |
| Sin `roles` | Basta con tener sesión |

También exporta `homePathForRole(rol)`: `/admin`, `/entity/dashboard` o `/user`.

---

## Animaciones

### `WelcomeAnimation`

Pantalla completa sobre fondo `bg-brand-gradient-deep` tras iniciar sesión: saludo con la mano, isotipo en un círculo blanco, "¡Hola, {nombre}!" y "Qué bueno verte de nuevo", con partículas.

| Prop | Descripción |
|---|---|
| `userName` | Primer nombre del perfil (`nombre_completo`). Si viene vacío, solo dice "¡Hola!". |
| `onComplete` | Se llama al terminar; `LoginPage` lo usa para redirigir al panel. |

### `LogoutAnimation`

Pantalla completa con el ícono de salida. Prop `onComplete`: se llama al terminar. El panel ciudadano cierra la sesión **después** de la animación (ver [02-INFRAESTRUCTURA.md](02-INFRAESTRUCTURA.md#cierre-de-sesión)).

Ambas animaciones se vuelven instantáneas si el sistema tiene activado *reducir movimiento*.
