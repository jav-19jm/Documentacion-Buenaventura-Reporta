# 01 · Visión general del frontend

## Información del proyecto

| Campo | Valor |
|---|---|
| Nombre | Buenaventura Reporta |
| Versión | 0.2.1 |
| Tipo | SPA (Single Page Application) |
| Runtime | Vite 6 + React 18 + TypeScript 5.8 |
| Backend | API REST propia en Laravel ([documentación](../backend/00-INDICE.md)) |
| Aplicación publicada | http://buenaventura.ds1.eleueleo.com/ |

## Qué es

Plataforma ciudadana de Buenaventura (Valle del Cauca) para reportar incidencias urbanas con foto y ubicación (luminarias dañadas, basura, semáforos, fugas de agua…), verlas en un mapa público y seguir su estado mientras la entidad responsable las atiende. Es un **proyecto ciudadano y académico, independiente de la Alcaldía**.

| Rol | Qué hace en el frontend |
|---|---|
| Visitante | Landing, mapa público con filtros, registro e inicio de sesión. |
| Ciudadano | Panel con inicio, mapa, mis reportes, noticias, servicios, perfil y creación de reportes. |
| Entidad | Panel institucional: reportes asignados, estadísticas, perfil y auditoría. |
| Administrador | Panel de gestión de reportes, usuarios, entidades, noticias y servicios del mapa. |

---

## Stack

### Base

| Tecnología | Versión | Uso |
|---|---|---|
| React | 18.3 | Interfaz |
| TypeScript | ~5.8 | Tipado estricto (`noUnusedLocals`, `noUnusedParameters`) |
| Vite | 6.4 | Servidor de desarrollo y compilación |
| React Router | 7.13 | Rutas (`createBrowserRouter`) |
| Axios | 1.x | Peticiones a la API, con interceptores de sesión |

### Interfaz

| Tecnología | Uso |
|---|---|
| Tailwind CSS 4.1 (`@tailwindcss/vite`) | Estilos con clases utilitarias y tokens de marca en `theme.css` |
| tw-animate-css | Animaciones de entrada (`animate-in`, `fade-in`…) |
| clsx + tailwind-merge | Función `cn()` para combinar clases |
| Motion 12 (Framer Motion) | Animaciones de bienvenida, cierre de sesión y transiciones |
| Lucide React | Íconos |
| Recharts | Gráficos de los paneles de administración y entidad |
| Sonner | Notificaciones *toast* |
| Leaflet 1.9 + React Leaflet 4.2 | Mapas con teselas de OpenStreetMap |
| Fuente Nunito (Google Fonts) | Tipografía redondeada, acorde al logo |

### Herramientas de desarrollo

| Herramienta | Uso |
|---|---|
| ESLint 10 + typescript-eslint + react-hooks + react-refresh | `npm run lint` |
| GitHub Actions | Despliegue automático a un VPS por SSH al hacer push a `main` |

---

## Scripts

```bash
npm run dev        # Servidor de desarrollo (http://localhost:5173)
npm run build      # tsc -b + vite build → dist/
npm run preview    # Sirve dist/ localmente
npm run typecheck  # Solo comprobación de tipos
npm run lint       # ESLint
```

---

## Configuración

### Variables de entorno (`.env`)

| Variable | Ejemplo | Descripción |
|---|---|---|
| `VITE_API_URL` | `http://localhost:8000/api` | URL base de la API. Se incrusta al compilar y es pública. Por defecto, `http://localhost:8000/api`. |

### `vite.config.ts`

- Plugins: `@vitejs/plugin-react` y `@tailwindcss/vite`.
- Alias `@` → `./src`.
- `assetsInclude: ['**/*.svg', '**/*.csv']`: los SVG se importan como URL (así se usan los logos en `BrandLogo`).

### `index.html`

- `lang="es"`, título y descripción para buscadores y redes sociales (Open Graph).
- `theme-color` `#0a5caa` (azul de la marca) para la barra del navegador en móviles.
- Favicon: `public/favicon.svg` (el isotipo del logo).
- Carga la fuente **Nunito** desde Google Fonts.

### `tsconfig.app.json`

Target ES2023, `moduleResolution: bundler`, JSX automático, modo estricto y `noUnusedLocals` / `noUnusedParameters`: un import sin usar rompe el build.

### `public/`

| Archivo | Uso |
|---|---|
| `favicon.svg` | Isotipo del logo (pin + colina + sol + ola). También se usa como logo en la interfaz. |
| `notification.mp3` | Sonido de la campana cuando llega una notificación nueva. |
| `.htaccess` | Redirige todas las rutas a `index.html` en Apache (necesario para la SPA). |
| `icons.svg`, `robots.txt` | Sprite de íconos y reglas para buscadores. |

---

## Punto de entrada

### `src/main.tsx`

Monta `<App />` en `#root` e importa `styles/index.css` (fuentes → Tailwind → tema → estilos de Leaflet y movimiento reducido).

### `src/App.tsx`

```tsx
<AuthProvider>
  <Toaster position="top-right" richColors />
  <RouterProvider router={router} />
</AuthProvider>
```

1. `AuthProvider` restaura la sesión al cargar (`GET /auth/me`) y la expone con `useAuth()`.
2. `Toaster` muestra los mensajes de éxito y error.
3. `RouterProvider` carga las rutas de `routes.tsx`.

### `src/routes.tsx`

Resumen (detalle en [07-PAGINAS-Y-RUTAS.md](07-PAGINAS-Y-RUTAS.md)):

| Grupo | Rutas | Protección |
|---|---|---|
| Públicas | `/`, `/map`, `/login`, `/register`, `/forgot-password`, `/reset-password`, `/entity/login/:entityId`, `/report/:id` | Ninguna |
| Panel ciudadano (dentro de `UserLayout`) | `/user`, `/user/map`, `/user/reports`, `/user/news`, `/user/services`, `/report/new`, `/profile` | Sesión iniciada |
| Administración | `/admin` | Rol `administrador` |
| Entidad | `/entity/dashboard`, `/entity/dashboard/:entityId`, `/entity/report/:id` | Rol `entidad` |
| Cualquier otra | `*` | Redirige a `/` |

---

## Convenciones

- **Textos en español**, tuteando al usuario y sin prometer en nombre de la Alcaldía (ver `PRODUCT.md` del repositorio).
- **Las páginas no llaman a Axios directamente**: usan las funciones de `src/api/`, que devuelven `{ data, error }`.
- **Colores de marca con tokens** (`brand`, `leaf`, `sun`), no colores sueltos de Tailwind. Los verdes y amarillos de Tailwind se reservan para estados (resuelto, pendiente…).
- **Estados de reporte** siempre con `getReportStatus()` de `lib/report-status.ts`, para que etiqueta y color sean iguales en toda la app.
- **Accesibilidad**: etiquetas asociadas a sus campos, foco visible, áreas táctiles de al menos 44 px y alternativa para `prefers-reduced-motion`.
