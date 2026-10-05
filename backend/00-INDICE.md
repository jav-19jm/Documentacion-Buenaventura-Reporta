# Buenaventura Reporta · Documentación del backend (API)

> API REST en **Laravel 12** con autenticación **JWT** y base de datos **PostgreSQL**.
> Repositorio: [`jav-19jm/Buenaventura-Reporta-API`](https://github.com/jav-19jm/Buenaventura-Reporta-API)
> Última actualización: 5 de octubre de 2026

---

## Empieza aquí

| Si quieres… | Lee |
|---|---|
| Instalar la API en tu computador (XAMPP, Composer, PostgreSQL, SQL) | [`GUIA-DE-INSTALACION.md`](GUIA-DE-INSTALACION.md) |
| Ver cada endpoint con sus parámetros y respuestas, y probarlo | La referencia interactiva de la API (`index.html` en la raíz de esta documentación, generada desde `openapi.json`) |

## Documentos

| # | Archivo | Contenido |
|---|---|---|
| — | [`GUIA-DE-INSTALACION.md`](GUIA-DE-INSTALACION.md) | Instalación paso a paso en Windows y solución de problemas. |
| 01 | [`01-GENERAL.md`](01-GENERAL.md) | Qué hace la API, stack, estructura de carpetas, variables de entorno y comandos. |
| 02 | [`02-BASE-DE-DATOS.md`](02-BASE-DE-DATOS.md) | Diagrama entidad-relación, tablas, valores permitidos, migraciones, seeders y scripts SQL. |
| 03 | [`03-AUTENTICACION-Y-SEGURIDAD.md`](03-AUTENTICACION-Y-SEGURIDAD.md) | JWT, verificación de correo, recuperación de contraseña, roles, permisos, límites de peticiones y CORS. |
| 04 | [`04-ENDPOINTS.md`](04-ENDPOINTS.md) | Mapa de todas las rutas agrupadas por panel, con quién puede usarlas. |
| 05 | [`05-LOGICA-DE-NEGOCIO.md`](05-LOGICA-DE-NEGOCIO.md) | Servicios de dominio: crear reportes, cambios de estado, votos y reputación, insignias, notificaciones y auditoría. |
| 06 | [`06-PRUEBAS.md`](06-PRUEBAS.md) | Cómo están organizadas y cómo se ejecutan las pruebas automáticas. |
| — | [`sql/`](sql/) | Scripts SQL para crear la base, el esquema y los datos del catálogo. |

---

## ¿Cómo encuentro algo?

| Necesitas… | Ve a… |
|---|---|
| Saber qué tabla guarda los votos o las insignias | [`02-BASE-DE-DATOS.md`](02-BASE-DE-DATOS.md) |
| Agregar una tabla o columna | [`02-BASE-DE-DATOS.md`](02-BASE-DE-DATOS.md) → *Agregar una migración* |
| Entender por qué un usuario recibe 403 | [`03-AUTENTICACION-Y-SEGURIDAD.md`](03-AUTENTICACION-Y-SEGURIDAD.md) → *Códigos de error* |
| Saber qué ruta usa el panel de entidad | [`04-ENDPOINTS.md`](04-ENDPOINTS.md) → *Panel de entidad* |
| Entender qué pasa al marcar un reporte como resuelto | [`05-LOGICA-DE-NEGOCIO.md`](05-LOGICA-DE-NEGOCIO.md) → *Cambio de estado* |
| Cómo se calcula la reputación | [`05-LOGICA-DE-NEGOCIO.md`](05-LOGICA-DE-NEGOCIO.md) → *Votos y reputación* |
| Probar un cambio antes de subirlo | [`06-PRUEBAS.md`](06-PRUEBAS.md) |

## Relación con el frontend

El frontend (React + Vite) consume esta API con Axios desde `src/api/`. Su documentación está en [`../frontend/`](../frontend/00-INDICE.md). Ambos se levantan por separado:

| Proyecto | URL en desarrollo |
|---|---|
| API (este repo) | `http://localhost:8000/api` |
| Frontend | `http://localhost:5173` |
