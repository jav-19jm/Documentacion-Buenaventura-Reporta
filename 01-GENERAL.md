# 01 — Visión General del Proyecto

## 🏷️ Información del Proyecto

| Campo | Valor |
|---|---|
| **Nombre** | Buenaventura Reporta |
| **Versión** | 0.2.1 |
| **Tipo** | SPA (Single Page Application) |
| **Runtime** | Vite 6.4.2 + React 18.3.1 + TypeScript |
| **Backend** | Supabase (PostgreSQL + Auth + Storage + Realtime) |
| **Módulos ES** | `"type": "module"` en `package.json` |

## 🎯 Descripción

**Buenaventura Reporta** es una plataforma de participación ciudadana para el municipio de Buenaventura (Colombia). Permite a los ciudadanos crear reportes geolocalizados sobre incidencias urbanas (alumbrado, basura, transporte, agua, vías, seguridad, salud), que son asignados a entidades gubernamentales responsables para su resolución.

El sistema implementa tres roles principales:
- **Ciudadano**: Crea reportes, vota, recibe notificaciones, gana insignias.
- **Entidad**: Gestiona reportes asignados, actualiza estados, se comunica con ciudadanos.
- **Administrador**: Panel completo de gestión de reportes, usuarios, entidades, noticias y servicios.

---

## ⚙️ Stack Tecnológico

### Core
| Tecnología | Uso |
|---|---|
| **React 18.3** | Framework UI |
| **TypeScript** | Tipado estático (target ES2023) |
| **Vite 6.4** | Bundler y dev server |
| **React Router 7** | Enrutamiento SPA |

### Estilado
| Tecnología | Uso |
|---|---|
| **Tailwind CSS 4.1** | Utility-first CSS |
| **theme.css** | Tokens de diseño (CSS custom properties) con soporte light/dark |
| **tw-animate-css** | Utilidades de animación |

### Componentes UI
| Tecnología | Uso |
|---|---|
| **Radix UI** | Primitivos accesibles (Dialog, Select, Tooltip, etc.) |
| **shadcn/ui** | Componentes construidos sobre Radix |
| **Lucide React** | Iconografía SVG |
| **Motion (Framer Motion)** | Animaciones declarativas |
| **Recharts** | Gráficos de datos (BarChart, PieChart) |

### Mapas
| Tecnología | Uso |
|---|---|
| **Leaflet 1.9** | Motor de mapas OpenStreetMap |
| **React Leaflet 4.2** | Binding React para Leaflet |

### Backend (Supabase)
| Servicio | Uso |
|---|---|
| **Supabase Auth** | Registro, login, recovery, JWT sessions |
| **Supabase Database** | PostgreSQL con RLS (Row Level Security) |
| **Supabase Storage** | Buckets: `avatars`, `report-images`, `news`, `logos` |
| **Supabase Realtime** | Suscripciones a cambios en `mensajes` y `notificaciones` |

### Otros
| Tecnología | Uso |
|---|---|
| **Sonner** | Notificaciones toast |
| **date-fns** | Formateo de fechas |
| **React Hook Form** | Formularios |
| **class-variance-authority** | Variantes de componentes |

---

## 🚀 Scripts disponibles

```bash
npm run dev      # Servidor de desarrollo (Vite HMR)
npm run build    # Build de producción → dist/
```

---

## 📁 Archivos de configuración raíz

### `index.html`
Punto de entrada HTML. Contiene:
- Meta viewport para diseño responsive.
- Favicon SVG (`/favicon.svg`).
- Div `#root` donde React monta la aplicación.
- Script module apuntando a `/src/main.tsx`.

### `vite.config.ts`
```typescript
// Plugins activos:
// 1. figmaAssetResolver() → Resuelve imports 'figma:asset/...' a src/assets/
// 2. react()              → Compilación JSX
// 3. tailwindcss()        → Procesamiento de Tailwind

// Alias configurados:
// '@' → './src'  (permite import '@/lib/auth')

// Assets soportados para import raw: *.svg, *.csv
```

### `tsconfig.app.json`
- **Target**: ES2023
- **Module**: ESNext con resolución `bundler`
- **JSX**: `react-jsx` (automatic runtime)
- **Linting**: `noUnusedLocals`, `noUnusedParameters`, `noFallthroughCasesInSwitch`
- **Scope**: Todo el directorio `src/`

### `package.json`
- 54 dependencias de producción
- 4 dependencias de desarrollo (Tailwind, Vite, tipos React)
- Override de pnpm para Vite 6.3.5

### `.env` (no versionado)
Variables de entorno esperadas:
```
VITE_SUPABASE_URL=https://xxx.supabase.co
VITE_SUPABASE_ANON_KEY=eyJ...
```
> Si no están definidas, el sistema usa el fallback de `src/environment/supabase.config.ts`.

---

## 🔄 Punto de entrada de la aplicación

### `src/main.tsx`
```typescript
import { createRoot } from "react-dom/client";
import App from "./app/App.tsx";
import "./styles/index.css";

createRoot(document.getElementById("root")!).render(<App />);
```
1. Importa el componente raíz `App`.
2. Importa los estilos globales (fonts → tailwind → theme → leaflet overrides).
3. Monta React en el div `#root`.

### `src/app/App.tsx`
```typescript
export default function App() {
  return (
    <>
      <Toaster position="top-right" richColors />
      <RouterProvider router={router} />
    </>
  );
}
```
1. **`<Toaster>`**: Renderiza el sistema global de notificaciones toast de Sonner.
2. **`<RouterProvider>`**: Provee el enrutamiento definido en `routes.ts`.

### `src/app/routes.ts`
Define 17 rutas usando `createBrowserRouter` de React Router v7:

| Ruta | Página | Acceso |
|---|---|---|
| `/` | `LandingPage` | Público |
| `/map` | `PublicMapPage` | Público |
| `/login` | `LoginPage` | Público |
| `/register` | `RegisterPage` | Público |
| `/forgot-password` | `ForgotPasswordPage` | Público |
| `/reset-password` | `UpdatePasswordPage` | Público (via email link) |
| `/user` | `UserDashboard` | Ciudadano autenticado |
| `/report/new` | `CreateReportPage` | Ciudadano autenticado |
| `/report/:id` | `ReportDetailPage` | Ciudadano autenticado |
| `/profile` | `ProfilePage` | Ciudadano autenticado |
| `/user/news` | `NewsPage` | Ciudadano autenticado |
| `/admin` | `AdminDashboard` | Administrador |
| `/entity/select` | `EntitySelection` | Público |
| `/entity/login/:entityId` | `EntityLogin` | Público |
| `/entity/dashboard` | `EntityDashboard` | Entidad autenticada |
| `/entity/dashboard/:entityId` | `EntityDashboardCustom` | Entidad autenticada |
| `/entity/report/:id` | `EntityReportDetail` | Entidad autenticada |

---

## 📂 Directorios especiales

### `public/`
| Archivo | Descripción |
|---|---|
| `favicon.svg` | Icono del sitio (SVG vectorial) |
| `icons.svg` | Sprite de iconos SVG |
| `notification.mp3` | Sonido de notificación push |

### `src/styles/`
| Archivo | Descripción |
|---|---|
| `fonts.css` | Importación de tipografías |
| `tailwind.css` | Directivas base de Tailwind (`@import "tailwindcss"`) |
| `theme.css` | 80+ CSS custom properties para Light/Dark mode con esquema Oklch |
| `index.css` | Importa los 3 anteriores + overrides de Leaflet popups |

### `src/environment/`
| Archivo | Descripción |
|---|---|
| `supabase.config.ts` | Credenciales hardcoded de Supabase como fallback para desarrollo en Figma Make |
