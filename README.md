# Documentación · Buenaventura Reporta

Plataforma ciudadana para reportar incidencias urbanas en Buenaventura (Valle del Cauca), verlas en un mapa público y seguir su estado mientras la entidad responsable las atiende. Proyecto ciudadano y académico, independiente de la Alcaldía.

| Parte | Repositorio | Tecnología | Documentación |
|---|---|---|---|
| Frontend | [`Buenaventura-Reporta`](https://github.com/jav-19jm/Buenaventura-Reporta) | React 18 + TypeScript + Vite + Tailwind CSS 4 + Leaflet | [`frontend/`](frontend/00-INDICE.md) |
| Backend (API) | [`Buenaventura-Reporta-API`](https://github.com/jav-19jm/Buenaventura-Reporta-API) | Laravel 12 + JWT + PostgreSQL | [`backend/`](backend/00-INDICE.md) |
| Referencia de la API | este repositorio | OpenAPI + Scalar | `index.html` (lee `openapi.json`) |

## Instalar el proyecto completo

Primero la API y luego el frontend:

1. [Guía de instalación del backend](backend/GUIA-DE-INSTALACION.md): XAMPP (PHP), Composer, PostgreSQL, scripts SQL, migraciones y usuarios de prueba.
2. [Guía de instalación del frontend](frontend/GUIA-DE-INSTALACION.md): Node.js, `.env` y servidor de desarrollo.

Con ambos corriendo:

| Servicio | URL |
|---|---|
| Frontend | http://localhost:5173 |
| API | http://localhost:8000/api |

## Contenido de este repositorio

```
Documentacion-Buenaventura-Reporta/
├── README.md          # Este archivo
├── frontend/          # Documentación del frontend + guía de instalación
├── backend/           # Documentación de la API + guía de instalación
│   └── sql/           # Scripts para crear la base de datos en PostgreSQL
├── index.html         # Referencia interactiva de la API (Scalar)
├── openapi.json       # Especificación OpenAPI de la API
└── logo.svg
```

## Equipo

- Jose Manuel Bonilla Payan
- Sebastian Gomez Lerma
- Daniel Enrique Renteria Hurtado
- Andres Felipe Andrade Cuasapud
- Jesus Eduardo Estupiñan Hernandez
- Edward Santiago May Restrepo

Última actualización: 5 de octubre de 2026.
