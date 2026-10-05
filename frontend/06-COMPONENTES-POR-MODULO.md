# 06 · Componentes por módulo

```
src/components/
├── auth/
│   └── AuthLayout.tsx
├── public/
│   ├── SiteFooter.tsx
│   └── ReviewsCarousel.tsx
├── user/
│   ├── layout/
│   │   ├── UserLayout.tsx
│   │   └── UserAvatar.tsx
│   ├── CityServicesFilter.tsx
│   ├── IncidentTypeSelector.tsx
│   ├── ReportCard.tsx
│   ├── WeatherWidget.tsx
│   └── NewsSection.tsx        # sin uso actual
└── admin/
    ├── ReportsManagement.tsx
    ├── UsersManagement.tsx
    ├── EntitiesManagement.tsx
    ├── NewsManagement.tsx
    └── ServicesManagement.tsx
```

---

## `auth/`

### `AuthLayout`

Pantalla dividida que comparten las cuatro páginas de autenticación (login, registro, recuperar y crear contraseña).

- **Escritorio (≥ 1024 px)**: a la izquierda, panel navy con la foto de las letras de Buenaventura, el logo blanco, el eslogan "Tu barrio, en el mapa de Buenaventura", tres beneficios y la nota "Proyecto ciudadano independiente. No es un canal oficial de la Alcaldía". A la derecha, el formulario sobre blanco.
- **Celular y tablet**: solo el formulario, con el logo a color arriba.

```tsx
<AuthLayout
  title="Hola de nuevo"
  description="Inicia sesión para reportar y seguir tus reportes."
  footer={<>¿Primera vez por aquí? <Link to="/register">Crea tu cuenta</Link></>}
>
  <form>…</form>
</AuthLayout>
```

| Prop | Descripción |
|---|---|
| `title` | Título del formulario (`<h1>`). |
| `description` | Texto bajo el título (acepta JSX). |
| `children` | El formulario. |
| `footer` | Pie separado por una línea (enlace a la otra página de auth). |
| `backTo` | Enlace de regreso arriba a la derecha. Por defecto `{ to: "/", label: "Volver al inicio" }`. |

---

## `public/`

### `SiteFooter`

Footer de la landing, sobre navy (`brand-950`):

| Columna | Contenido |
|---|---|
| Marca | Logo blanco, descripción y redes sociales. |
| Plataforma | Mapa de reportes, Cómo funciona, Crear cuenta, Iniciar sesión. |
| Puedes reportar | Luminarias dañadas, basura en la vía, semáforos dañados, fugas de agua. |
| Emergencias | Enlaces `tel:` a la línea 123 y a Bomberos (119). |

Abajo, una barra con el año actual y "Hecho en Buenaventura, Valle del Cauca".

> Las redes sociales apuntan a las páginas genéricas (`facebook.com`, `instagram.com`…) y están marcadas con un `TODO`: reemplázalas por las cuentas reales del proyecto.

### `ReviewsCarousel`

Reseñas de ciudadanos que se desplazan solas en un carrusel infinito (`animate-marquee`). Se pausan al pasar el mouse o al enfocar con el teclado y, con *reducir movimiento*, quedan quietas con desplazamiento manual. Los nombres llegan en mayúsculas y se muestran como nombre propio.

> Las reseñas están escritas en el código. Conviene reemplazarlas por testimonios reales.

---

## `user/`

### `layout/UserLayout`

Estructura de todo el panel ciudadano. En `routes.tsx` envuelve `/user`, `/user/map`, `/user/reports`, `/user/news`, `/user/services`, `/report/new` y `/profile`, y renderiza la página activa en un `<Outlet />`.

**Escritorio (≥ 1024 px): menú lateral**

- Logo, botón **Nuevo reporte** y dos grupos de enlaces:
  - *Mi panel*: Inicio, Mapa, Mis reportes.
  - *Ciudad*: Noticias, Servicios.
- Abajo: tarjeta del perfil (avatar, nombre, correo), **Cerrar sesión** y **Contraer menú**.
- Contraído, el menú queda en 80 px solo con íconos y muestra el nombre de cada uno al pasar el mouse o enfocar. La preferencia se guarda en `localStorage` (`br:sidebar-colapsado`).

**Celular y tablet: pestañas inferiores**

Barra fija abajo, como una app: **Inicio · Mapa · Reportar · Reportes · Noticias**. *Reportar* es un botón circular destacado en el centro. La barra respeta el área segura de los teléfonos con muesca (`env(safe-area-inset-bottom)`).

**Barra superior (todas las pantallas)**

Título de la página (según la ruta), campana de notificaciones y, en celular, el isotipo y el avatar con enlace al perfil.

**Agregar una sección al panel**

1. Crea la página en `src/pages/user/`.
2. Agrégala como hija de `UserLayout` en `routes.tsx`.
3. Agrega su título en `pageTitles` de `UserLayout.tsx`.
4. Agrégala a `mainNav` o `cityNav` (menú lateral) y, si es de uso frecuente en el celular, a `tabs`. Las pestañas inferiores admiten 4 enlaces más el botón central.

### `layout/UserAvatar`

Foto de perfil (`url_avatar`) o, si no hay, las iniciales del nombre sobre azul. Props: `profile` (`nombre_completo`, `url_avatar`) y `className` para el tamaño. También lo usa el encabezado del panel de administración.

### `CityServicesFilter`

Buscador y filtro por tipo de los servicios de la ciudad (`GET /services`), con dirección, teléfono y horario. Se usa en `/user/services`.

### `IncidentTypeSelector`

Cuadrícula de tipos de incidencia para el formulario de nuevo reporte. Props: `selectedType`, `onSelect(typeId)` y `types` (las categorías de la API; si no llegan, usa una lista por defecto). El ícono y el color se deducen del nombre de la categoría.

### `ReportCard`

Tarjeta de un reporte (título, ubicación, fecha, votos y estado) con acción opcional de eliminar. Props: `report`, `onClick`, `onDelete`. Se usa en la pestaña de reportes de **Mi perfil**.

### `WeatherWidget`

Clima actual de Buenaventura desde **Open-Meteo** (sin clave): botón con ícono y temperatura que despliega el estado del cielo, la humedad y el viento. Se usa en el saludo del Inicio del panel.

### `NewsSection` (sin uso actual)

Bloque de las 3 últimas noticias con modal de detalle. Lo usaba el panel anterior; el Inicio actual muestra las noticias en su propia columna. Se puede eliminar si no se vuelve a usar.

---

## `admin/`

Cada archivo es una pestaña del panel de administración (`/admin`) y carga sus propios datos desde `src/api/admin.ts`.

| Componente | Pestaña | Permite |
|---|---|---|
| `ReportsManagement` | Gestión de Reportes | Filtrar y buscar reportes, ver detalle, cambiar estado, asignar entidad, comentar en el chat y ocultar reportes. |
| `UsersManagement` | Moderación de Usuarios | Buscar usuarios, ver reputación, suspender o reactivar con motivo y cambiar el rol. |
| `EntitiesManagement` | Entidades | Crear entidades con su cuenta de acceso, editarlas y eliminarlas. |
| `NewsManagement` | Noticias | Crear, editar, publicar o retirar noticias y subir su imagen. |
| `ServicesManagement` | Servicios en Mapa | Crear, editar y eliminar servicios eligiendo su ubicación en `LocationPickerMap`. |
