# 04 · Mapa de endpoints

Todas las rutas están en `routes/api.php` y llevan el prefijo **`/api`** (en desarrollo: `http://localhost:8000/api`). Para ver parámetros, cuerpos y respuestas de ejemplo, y probar cada ruta, usa la referencia interactiva (`index.html` de esta documentación, generada desde `openapi.json`). También puedes listarlas con:

```bash
php artisan route:list --path=api
```

**Acceso:** 🌐 público · 🔑 sesión con cuenta activa · 🛡️ administrador · 🏢 cuenta de entidad · ⏱️ límite por minuto.

---

## Diagnóstico

| Método | Ruta | Acceso | Descripción |
|---|---|---|---|
| GET | `/prueba` | 🌐 | Comprueba que la API responde. |
| GET | `/up` *(sin prefijo `/api`)* | 🌐 | Health check de Laravel. |

## Autenticación (`/auth`)

| Método | Ruta | Acceso | Descripción |
|---|---|---|---|
| POST | `/auth/register` | 🌐 ⏱️10 | Registra un ciudadano y envía el correo de verificación. |
| POST | `/auth/login` | 🌐 ⏱️10 | Devuelve `{ token, token_type, expires_in, user }`. |
| POST | `/auth/refresh` | 🌐 ⏱️10 | Renueva el token (acepta tokens vencidos dentro de `JWT_REFRESH_TTL`). |
| POST | `/auth/forgot-password` | 🌐 ⏱️5 | Envía el correo de recuperación. |
| POST | `/auth/reset-password` | 🌐 ⏱️5 | Cambia la contraseña con el token del correo. |
| POST | `/auth/email/resend` | 🌐 ⏱️5 | Reenvía el correo de verificación. |
| GET | `/auth/verify-email/{id}/{hash}` | 🌐 ⏱️10 | Enlace firmado del correo; redirige a `FRONTEND_URL/login?verificado=…`. |
| GET | `/auth/me` | 🔑 | Perfil completo del usuario autenticado. |
| POST | `/auth/logout` | 🔑 | Invalida el token. |

## Panel ciudadano

### Lectura pública

| Método | Ruta | Descripción |
|---|---|---|
| GET | `/report-categories` | Categorías activas, por nombre. |
| GET | `/entities` | Entidades activas, por nombre. |
| GET | `/services` | Servicios activos del mapa, por nombre. |
| GET | `/news` | Noticias publicadas, las más recientes primero. |
| GET | `/reports` | Reportes visibles, con su autor (`perfiles`) y entidad (`entidades`). Alimenta los mapas. |
| GET | `/reports/{id}` | Detalle de un reporte. |
| GET | `/users/{id}` | Perfil: completo si eres tú, público (sin correo ni teléfono) si es otra persona. |
| GET | `/users/{id}/badges` | Insignias de un usuario, las más recientes primero. |

### Con sesión (🔑)

| Método | Ruta | Descripción |
|---|---|---|
| GET | `/users/me/reports` | Reportes del usuario autenticado. |
| POST | `/reports` ⏱️10 | Crea un reporte. Si no se envía `id_entidad`, se asigna la entidad responsable de la categoría. |
| POST | `/reports/{id}/image` | Sube o reemplaza la foto (solo el autor; jpg/png/webp, máx. 5 MB). |
| DELETE | `/reports/{id}` | El autor oculta su reporte (borrado lógico). |
| POST | `/reports/{id}/votes` ⏱️30 | Vota `{ tipo_voto: voto_positivo \| voto_negativo }`. Votar lo mismo dos veces responde 422. |
| PATCH | `/reports/{id}/status` | Cambia el estado. Solo administración, moderación o la entidad asignada. |
| GET | `/reports/{id}/messages` | Chat de seguimiento (autor, administración y entidad asignada). |
| POST | `/reports/{id}/messages` ⏱️20 | Envía un mensaje al chat. |
| PATCH | `/messages/{id}` | Edita un mensaje propio (primeros 5 minutos). |
| DELETE | `/messages/{id}` | Borra un mensaje propio (primeros 5 minutos). |
| GET | `/users/me/notifications` | Últimas 100 notificaciones, las más recientes primero. |
| PATCH | `/notifications/{id}/read` | Marca una notificación como leída. |
| DELETE | `/notifications/{id}` | Borra una notificación propia. |
| POST | `/users/me/avatar` | Sube la foto de perfil (jpg/png/webp, máx. 2 MB). |
| POST | `/users/{id}/report-abuse` ⏱️5 | Denuncia a un usuario `{ motivo, id_reporte? }`; notifica a los administradores. |

## Panel de administración (`/admin`, 🛡️)

| Método | Ruta | Descripción |
|---|---|---|
| GET | `/admin/stats` | Reportes visibles por estado y categoría, usuarios por estado y total de entidades. |
| GET | `/admin/users` | Todos los usuarios, los más recientes primero. |
| PATCH | `/admin/users/{id}/status` | Activa, inactiva o suspende `{ estado, motivo? }`. El bloqueo aplica de inmediato. |
| PATCH | `/admin/users/{id}/role` | Cambia el rol (ciudadano, moderador o administrador; el rol entidad se gestiona en Entidades). |
| GET | `/admin/reports` | Todos los reportes, incluidos los ocultos. |
| PATCH | `/admin/reports/{id}/entity` | Asigna el reporte a una entidad y avisa al autor y a la entidad. |
| DELETE | `/admin/reports/{id}` | Oculta el reporte (borrado lógico). |
| GET | `/admin/entities` | Todas las entidades, incluidas las inactivas. |
| POST | `/admin/entities` | Crea la entidad **y su cuenta institucional** (`email`, `password`). |
| PUT | `/admin/entities/{id}` | Actualiza la entidad y sincroniza nombre, correo y, si llega, contraseña de su cuenta. |
| DELETE | `/admin/entities/{id}` | Elimina la entidad: sus reportes quedan sin asignar y sus cuentas se desactivan. |
| GET | `/admin/news` | Todas las noticias (publicadas y borradores). |
| POST | `/admin/news` | Crea una noticia. |
| PUT | `/admin/news/{id}` | Edita una noticia. |
| PATCH | `/admin/news/{id}/publish` | Publica o retira. La primera publicación notifica a todos los ciudadanos activos. |
| POST | `/admin/news/{id}/image` | Sube la imagen (jpg/png/webp, máx. 5 MB). |
| DELETE | `/admin/news/{id}` | Borra la noticia. |
| GET | `/admin/services` | Todos los servicios, incluidos los inactivos. |
| POST | `/admin/services` | Crea un servicio; si nace activo, notifica a los ciudadanos. |
| PUT | `/admin/services/{id}` | Edita un servicio. |
| DELETE | `/admin/services/{id}` | Borra un servicio. |

## Panel de entidad (`/entity`, 🏢)

Todas las acciones se limitan a la entidad vinculada a la cuenta (middleware `con_entidad`). Para cambiar el estado de un reporte se usa `PATCH /reports/{id}/status`.

| Método | Ruta | Descripción |
|---|---|---|
| GET | `/entity` | Datos de la entidad. |
| PUT | `/entity` | Edita descripción, teléfono, sitio web y color. Nombre, slug, tipo y correo solo los cambia la administración. |
| POST | `/entity/logo` | Sube el logo (jpg/png/webp, máx. 2 MB). |
| GET | `/entity/reports` | Reportes asignados, los más recientes primero. |
| GET | `/entity/stats` | Conteo de los reportes asignados por estado. |
| GET | `/entity/activity` | Últimas 50 acciones de la auditoría. |

---

## Uso desde el frontend

Cada ruta tiene una función en `src/api/` del frontend (por ejemplo, `POST /reports` → `createReport()` en `src/api/reports.ts`). La tabla completa está en [`../frontend/03-CAPA-API.md`](../frontend/03-CAPA-API.md).
