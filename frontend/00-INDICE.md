# Buenaventura Reporta · Documentación del frontend

> Aplicación web en **React 18 + TypeScript + Vite**, con **Tailwind CSS 4** y mapas **Leaflet**. Consume la API REST del backend (Laravel) con Axios.
> Repositorio: [`jav-19jm/Buenaventura-Reporta`](https://github.com/jav-19jm/Buenaventura-Reporta) · Versión 0.2.1
> Última actualización: 5 de octubre de 2026

---

## Empieza aquí

| Si quieres… | Lee |
|---|---|
| Instalar y levantar el frontend en tu computador | [`GUIA-DE-INSTALACION.md`](GUIA-DE-INSTALACION.md) |
| Instalar la API que necesita el frontend | [`../backend/GUIA-DE-INSTALACION.md`](../backend/GUIA-DE-INSTALACION.md) |

## Documentos

| # | Archivo | Contenido |
|---|---|---|
| — | [`GUIA-DE-INSTALACION.md`](GUIA-DE-INSTALACION.md) | Node.js, dependencias, `.env`, scripts, despliegue y problemas comunes. |
| 01 | [`01-GENERAL.md`](01-GENERAL.md) | Stack, estructura de carpetas, configuración, punto de entrada y rutas. |
| 02 | [`02-INFRAESTRUCTURA.md`](02-INFRAESTRUCTURA.md) | Arquitectura frontend ↔ API, sesión con JWT, roles y modelos de datos (`src/types`). |
| 03 | [`03-CAPA-API.md`](03-CAPA-API.md) | `src/api/` (cliente Axios y funciones por recurso), `src/context`, `src/hooks` y `src/lib`. |
| 04 | [`04-COMPONENTES-UI.md`](04-COMPONENTES-UI.md) | Sistema de diseño: colores de marca, tipografía y componentes base (`Button`, `Input`, `Card`, `Badge`…). |
| 05 | [`05-COMPONENTES-COMUNES.md`](05-COMPONENTES-COMUNES.md) | `src/components/common/`: logo, mapas, filtros, notificaciones, rutas protegidas y animaciones. |
| 06 | [`06-COMPONENTES-POR-MODULO.md`](06-COMPONENTES-POR-MODULO.md) | Componentes de `auth/`, `public/`, `user/` (incluido el layout del panel) y `admin/`. |
| 07 | [`07-PAGINAS-Y-RUTAS.md`](07-PAGINAS-Y-RUTAS.md) | Cada página: qué muestra, qué datos carga y quién puede verla. |

La documentación de la API (tablas, endpoints, seguridad) está en [`../backend/`](../backend/00-INDICE.md).

---

## ¿Cómo encuentro algo?

| Necesitas… | Ve a… |
|---|---|
| Levantar el proyecto por primera vez | [`GUIA-DE-INSTALACION.md`](GUIA-DE-INSTALACION.md) |
| Saber qué página carga una URL | [`07-PAGINAS-Y-RUTAS.md`](07-PAGINAS-Y-RUTAS.md) → *Tabla de rutas* |
| Llamar a un endpoint nuevo desde el frontend | [`03-CAPA-API.md`](03-CAPA-API.md) → *Agregar una función* |
| Entender cómo se renueva la sesión | [`02-INFRAESTRUCTURA.md`](02-INFRAESTRUCTURA.md) → *Sesión* |
| Usar los colores y botones de la marca | [`04-COMPONENTES-UI.md`](04-COMPONENTES-UI.md) |
| Agregar una sección al menú lateral del panel ciudadano | [`06-COMPONENTES-POR-MODULO.md`](06-COMPONENTES-POR-MODULO.md) → *UserLayout* |
| Mostrar el estado de un reporte con su etiqueta y color | [`03-CAPA-API.md`](03-CAPA-API.md) → *`lib/report-status.ts`* |

---

## Estructura del proyecto

```
Buenaventura-Reporta/
├── .github/workflows/        # Despliegue automático por SSH
├── public/                   # favicon.svg (logo), notification.mp3, .htaccess
├── src/
│   ├── api/                  # Cliente Axios y una función por endpoint
│   ├── assets/               # Logos (SVG) y fotos de Buenaventura (WebP)
│   ├── components/
│   │   ├── admin/            # Pestañas del panel de administración
│   │   ├── auth/             # AuthLayout (pantalla dividida de login/registro)
│   │   ├── common/           # Compartidos: logo, mapas, notificaciones, animaciones…
│   │   ├── public/           # Footer y reseñas de la landing
│   │   ├── ui/               # Componentes base del sistema de diseño
│   │   └── user/             # Panel ciudadano (layout con menú lateral y pestañas)
│   ├── context/              # AuthContext (sesión global)
│   ├── hooks/                # useAuth, useReportsData, useMapFilters
│   ├── lib/                  # Utilidades: cn(), estados de reporte, tipos de servicio
│   ├── pages/                # admin/, auth/, entity/, public/, user/
│   ├── styles/               # Tailwind, tokens de marca y estilos globales
│   ├── types/                # Modelos de datos (espejo de las tablas del backend)
│   ├── App.tsx               # Proveedores globales (sesión, toasts, router)
│   ├── main.tsx              # Punto de entrada
│   └── routes.tsx            # Definición de rutas
├── .env.example              # VITE_API_URL
├── index.html                # HTML base, fuente Nunito y metadatos
├── vite.config.ts
└── package.json
```

---

## Historial de esta documentación

| Fecha | Cambio |
|---|---|
| 17 de mayo de 2026 | Primera versión (arquitectura con Supabase). |
| 5 de octubre de 2026 | Reescrita para la arquitectura actual: API Laravel + JWT, nueva estructura `src/api`, rebranding con el logo nuevo, panel ciudadano con menú lateral y pestañas inferiores, mapa público con filtros y guía de instalación. Se reemplazaron `03-LIB-BACKEND`, `05-COMPONENTES-ANIMATIONS`, `06-COMPONENTES-FIGMA`, `07-COMPONENTES-FUNCIONALES` y `08-PAGES`. |
