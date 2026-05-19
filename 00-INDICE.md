# 📚 Buenaventura Reporta — Índice de Documentación

> Documentación técnica completa del proyecto **Buenaventura Reporta** v0.2.1  
> Última actualización: 17 de mayo de 2026

---

## 🗂️ Estructura de Documentos

La documentación está organizada en **módulos numerados** para facilitar su consulta. A continuación se describe el orden recomendado de lectura para el equipo de desarrollo.

### Para empezar (Lectura obligatoria)

| # | Archivo | Descripción |
|---|---------|-------------|
| 00 | `00-INDICE.md` | **Este archivo.** Mapa general de toda la documentación. |
| 01 | `01-GENERAL.md` | Visión general del proyecto, stack tecnológico, scripts, estructura de carpetas raíz y archivos de configuración. |
| 02 | `02-INFRAESTRUCTURA.md` | Esquemas de base de datos, diagramas ER, diagramas de clases TS, arquitectura de servicios y flujo de datos. |

### Backend & Servicios (Capa de datos)

| # | Archivo | Descripción |
|---|---------|-------------|
| 03 | `03-LIB-BACKEND.md` | Documentación completa de `src/lib/`: cada archivo, cada función, parámetros, retornos, tablas Supabase que consulta y endpoints implícitos. |

### Frontend — Componentes

| # | Archivo | Descripción |
|---|---------|-------------|
| 04 | `04-COMPONENTES-UI.md` | Módulo `components/ui/`: Componentes primitivos reutilizables (Button, Card, Badge, Input, etc.) y catálogo Radix/shadcn. |
| 05 | `05-COMPONENTES-ANIMATIONS.md` | Módulo `components/animations/`: Animaciones de bienvenida y cierre de sesión con Framer Motion. |
| 06 | `06-COMPONENTES-FIGMA.md` | Módulo `components/figma/`: Utilidades de integración con Figma Make (ImageWithFallback). |
| 07 | `07-COMPONENTES-FUNCIONALES.md` | Componentes funcionales raíz de `components/`: ReportsMap, NotificationBell, WeatherWidget, NewsSection, etc. |

### Frontend — Páginas

| # | Archivo | Descripción |
|---|---------|-------------|
| 08 | `08-PAGES.md` | Todas las páginas de la aplicación: públicas, de usuario, de entidad y de administrador. Detalle línea por línea de las funciones que consumen `src/lib/`. |

---

## 🧭 ¿Cómo buscar algo específico?

| Necesitas... | Ve a... |
|---|---|
| Entender la arquitectura general y cómo levantar el proyecto | `01-GENERAL.md` |
| Ver las tablas de la base de datos y sus relaciones | `02-INFRAESTRUCTURA.md` |
| Saber qué función usar para crear un reporte o votar | `03-LIB-BACKEND.md` → sección `reports.ts` |
| Crear un nuevo componente con el Design System | `04-COMPONENTES-UI.md` |
| Entender cómo funcionan las notificaciones en tiempo real | `07-COMPONENTES-FUNCIONALES.md` → NotificationBell |
| Saber qué rutas existen y qué página cargan | `08-PAGES.md` → tabla de rutas |
| Ver cómo funciona la autenticación y el hook `useAuth` | `03-LIB-BACKEND.md` → sección auth.ts y useAuth |

---

## 📁 Estructura de carpetas del proyecto

```
Buenaventura-Reporta/
├── docs/                        # ← Documentación (estás aquí)
├── public/                      # Archivos estáticos (favicon, sonidos)
├── src/
│   ├── app/
│   │   ├── components/
│   │   │   ├── animations/      # Componentes de animación
│   │   │   ├── figma/           # Utilidades de Figma Make
│   │   │   ├── ui/              # Design System (shadcn + custom)
│   │   │   └── *.tsx            # Componentes funcionales
│   │   ├── lib/
│   │   │   └── utils.ts         # Utilidad cn() para clases CSS
│   │   ├── pages/
│   │   │   ├── admin/           # Panel administrativo
│   │   │   ├── entity/          # Dashboard de entidades
│   │   │   ├── user/            # Dashboard ciudadano
│   │   │   └── *.tsx            # Páginas públicas (Landing, Login, etc.)
│   │   ├── supabase/
│   │   │   └── supabase.ts      # Cliente Supabase + Tipos/Interfaces TS
│   │   ├── App.tsx              # Componente raíz
│   │   └── routes.ts            # Definición de rutas
│   ├── environment/
│   │   └── supabase.config.ts   # Credenciales de Supabase (fallback)
│   ├── hooks/
│   │   └── useAuth.ts           # Hook de autenticación global
│   ├── lib/                     # ← Capa de servicios / lógica de negocio
│   │   ├── admin.ts
│   │   ├── auth.ts
│   │   ├── badges.ts
│   │   ├── entities.ts
│   │   ├── notifications.ts
│   │   ├── reports.ts
│   │   ├── service-types.ts
│   │   └── test-connection.ts
│   ├── styles/
│   │   ├── fonts.css
│   │   ├── index.css            # CSS principal + Leaflet overrides
│   │   ├── tailwind.css
│   │   └── theme.css            # Tokens de diseño (light/dark)
│   └── main.tsx                 # Punto de entrada React
├── index.html                   # HTML shell
├── package.json
├── vite.config.ts
├── tsconfig.json
└── tsconfig.app.json
```
