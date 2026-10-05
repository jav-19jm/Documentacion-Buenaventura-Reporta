# 01 · Visión general del backend

## Qué hace la API

La API de **Buenaventura Reporta** guarda y sirve todo lo que usa la plataforma ciudadana:

- **Ciudadanos**: se registran, verifican su correo, crean reportes geolocalizados con foto, votan reportes, conversan con la entidad en un chat de seguimiento, reciben notificaciones y ganan insignias.
- **Entidades** (Acueducto, Policía, Secretaría de Obras…): ven los reportes que tienen asignados, cambian su estado, editan su perfil institucional y consultan su auditoría.
- **Administración**: gestiona usuarios, reportes, entidades, noticias y los servicios que aparecen en el mapa, y ve estadísticas globales.

Reemplaza al backend anterior en Supabase. Por eso conserva los nombres de tablas y columnas en español (`reportes`, `id_usuario`, `fecha_creacion`…) y las respuestas usan las mismas claves que esperaba el frontend (por ejemplo, el autor de un reporte llega en `perfiles` y la entidad en `entidades`).

---

## Stack

| Tecnología | Versión | Uso |
|---|---|---|
| PHP | ^8.2 | Lenguaje |
| Laravel | 12 | Framework (rutas, Eloquent, validación, colas, correo) |
| tymon/jwt-auth | ^2.3 | Autenticación por token JWT (guard `api`) |
| PostgreSQL | 16 – 18 | Base de datos de desarrollo y producción |
| SQLite (en memoria) | — | Base de datos de las pruebas automáticas |
| PHPUnit | 11 | Pruebas |
| Laravel Pint | 1.x | Formato de código (`./vendor/bin/pint`) |

La API **no tiene vistas propias**: solo responde JSON bajo el prefijo `/api`. Las únicas plantillas Blade son las de los correos (`resources/views/emails`).

---

## Estructura de carpetas

```
Buenaventura-Reporta-API/
├── app/
│   ├── Enums/               # Valores permitidos (estados, roles, tipos…) como enums de PHP
│   ├── Http/
│   │   ├── Controllers/     # Panel ciudadano, autenticación, panel de entidad
│   │   │   └── Admin/       # Panel de administración
│   │   ├── Middleware/      # activo, rol, con_entidad
│   │   ├── Requests/        # Validación de formularios (reportes, entidades, noticias, servicios)
│   │   └── Resources/       # Forma del JSON de respuesta (reportes, mensajes, noticias…)
│   ├── Models/              # Modelos Eloquent (User, Reporte, Entidad…)
│   ├── Notifications/       # Correos de verificación y recuperación de contraseña
│   ├── Policies/            # ReportePolicy: quién gestiona, cambia estado o chatea en un reporte
│   ├── Services/            # Lógica de negocio (ver 05-LOGICA-DE-NEGOCIO.md)
│   └── Support/             # ArchivosPublicos: subir y borrar imágenes
├── bootstrap/app.php        # Rutas, alias de middleware y respuestas JSON de error
├── config/                  # cors.php, jwt.php, auth.php, filesystems.php…
├── database/
│   ├── factories/           # Datos falsos para pruebas y seeders
│   ├── migrations/          # Esquema de la base (fuente de verdad)
│   └── seeders/             # Catálogo, administrador y datos de demostración
├── lang/es/validation.php   # Mensajes de validación en español
├── resources/views/emails/  # Plantillas de correo
├── routes/api.php           # Todas las rutas de la API
├── storage/app/public/      # Imágenes subidas (servidas en /storage)
└── tests/                   # Pruebas Feature por panel
```

---

## Variables de entorno

Se definen en `.env` (plantilla: `.env.example`). Las importantes para este proyecto:

| Variable | Ejemplo | Descripción |
|---|---|---|
| `APP_ENV` | `local` | Con `local`, `db:seed` crea también los datos de demostración. |
| `APP_KEY` | *(generada)* | `php artisan key:generate`. |
| `APP_URL` | `http://localhost:8000` | URL pública de la API. Base de las URL de imágenes y de los enlaces firmados. |
| `FRONTEND_URL` | `http://localhost:5173` | URL del frontend: destino de los enlaces de correo y origen permitido por CORS. |
| `CORS_ALLOWED_ORIGINS` | `https://app.ejemplo.com,http://localhost:5173` | Opcional. Orígenes permitidos separados por coma. Si no se define, se usa `FRONTEND_URL`. |
| `APP_LOCALE` | `es` | Idioma de los mensajes de validación. |
| `DB_*` | `pgsql`, `127.0.0.1`, `5432`, `buenaventura_reporta` | Conexión a PostgreSQL. |
| `JWT_SECRET` | *(generado)* | `php artisan jwt:secret`. |
| `JWT_TTL` | `60` | Minutos de vigencia del token. |
| `JWT_REFRESH_TTL` | `20160` | Minutos durante los que un token vencido se puede renovar (2 semanas). |
| `MAIL_MAILER` | `log` / `smtp` | `log` escribe los correos en `storage/logs/laravel.log`. |
| `MAIL_FROM_ADDRESS` | `no-reply@…` | Remitente de los correos. |
| `ADMIN_EMAIL` / `ADMIN_PASSWORD` | — | Administrador inicial que crea `php artisan db:seed`. |
| `QUEUE_CONNECTION` | `sync` | Los trabajos se ejecutan en el momento; no hace falta un *worker*. |

---

## Comandos frecuentes

| Comando | Para qué |
|---|---|
| `php artisan serve` | Levanta la API en `http://localhost:8000`. |
| `php artisan migrate` | Aplica las migraciones pendientes. |
| `php artisan migrate --seed` | Migra y carga catálogo, administrador y (en `local`) datos de demostración. |
| `php artisan db:seed` | Vuelve a ejecutar los seeders (no duplica datos). |
| `php artisan migrate:fresh --seed` | **Borra todas las tablas** y recrea la base desde cero. Solo en desarrollo. |
| `php artisan storage:link` | Publica `storage/app/public` en `/storage` (necesario para ver imágenes). |
| `php artisan route:list --path=api` | Lista todas las rutas de la API. |
| `php artisan config:clear` | Limpia la caché de configuración tras editar el `.env`. |
| `php artisan test` | Ejecuta las pruebas. |
| `./vendor/bin/pint` | Formatea el código PHP con el estilo del proyecto. |

---

## Convenciones del código

- **Identificadores UUID** en todas las tablas (UUID v7, ordenables por fecha). Las rutas solo aceptan UUID válidos: cualquier otro valor responde 404 sin consultar la base.
- **Fechas**: columnas `fecha_creacion` y `fecha_actualizacion` (con zona horaria) en lugar de `created_at` / `updated_at`.
- **Respuestas sin envoltorio**: los *Resources* devuelven el objeto o el arreglo directamente, sin `{ "data": ... }` (`JsonResource::withoutWrapping()` en `AppServiceProvider`).
- **Errores siempre en JSON** bajo `/api`, aunque el cliente no envíe `Accept: application/json`. Formato: `{ "message": "...", "codigo": "..." }` (el campo `codigo` solo aparece en algunos errores; ver [03-AUTENTICACION-Y-SEGURIDAD.md](03-AUTENTICACION-Y-SEGURIDAD.md#códigos-de-error)).
- **Borrado lógico de reportes**: eliminar un reporte pone `visible = false`; no se borra la fila.
- **Mensajes al usuario en español**, escritos en los controladores y en `lang/es/validation.php`.
- **Lógica de negocio en `app/Services`**: los controladores validan, autorizan y delegan.
