# 06 · Pruebas automáticas

## Ejecutar

```bash
php artisan test                                  # todas
php artisan test --filter=VotoTest                # un archivo
php artisan test --filter=test_repetir_el_mismo_voto_es_rechazado   # una prueba por nombre
php artisan test tests/Feature/PanelCiudadano     # una carpeta
```

Resultado al 5 de octubre de 2026: **86 pruebas aprobadas (336 aserciones)**, en unos 15 segundos.

## Entorno de pruebas

`phpunit.xml` fija un entorno aislado, así que las pruebas **no tocan tu base PostgreSQL ni envían correos**:

| Ajuste | Valor |
|---|---|
| Base de datos | SQLite en memoria (`DB_CONNECTION=sqlite`, `DB_DATABASE=:memory:`). Requiere la extensión `pdo_sqlite`. |
| Correo | `MAIL_MAILER=array` (se capturan en memoria) |
| Caché y sesión | `array` |
| Colas | `sync` |
| `APP_KEY` y `JWT_SECRET` | Valores fijos de prueba |
| `BCRYPT_ROUNDS` | 4 (más rápido) |

Cada prueba parte de una base vacía (`RefreshDatabase`). Las imágenes de prueba salen del trait `tests/Concerns/ImagenDePrueba.php`, que genera un PNG real de 1×1 px para no depender de la extensión GD.

## Organización

| Archivo | Qué cubre |
|---|---|
| `Auth/RegisterTest` | Registro de ciudadanos, validaciones y correo de verificación. |
| `Auth/LoginTest` | Credenciales, correo sin verificar, cuentas bloqueadas. |
| `Auth/SessionTest` | `me`, `logout` y renovación del token. |
| `Auth/EmailAndPasswordTest` | Verificación de correo, reenvío y recuperación de contraseña. |
| `PanelCiudadano/CatalogoTest` | Lectura pública de categorías, entidades, servicios y noticias. |
| `PanelCiudadano/ReporteTest` | Crear, listar, ver, ocultar reportes y subir su imagen. |
| `PanelCiudadano/VotoTest` | Votos, cambio de voto y reputación. |
| `PanelCiudadano/MensajeTest` | Chat de seguimiento y ventana de edición de 5 minutos. |
| `PanelCiudadano/PerfilYNotificacionesTest` | Perfil público y propio, avatar, notificaciones y denuncias. |
| `Admin/AccesoAdminTest` | Que las rutas `/admin` rechacen a quien no es administrador. |
| `Admin/UsuariosAdminTest` | Bloqueo de cuentas y cambio de rol. |
| `Admin/ReportesAdminTest` | Listado, asignación de entidad, cambio de estado y ocultar reportes. |
| `Admin/EntidadesAdminTest` | Crear, editar y eliminar entidades con su cuenta institucional. |
| `Admin/ContenidosAdminTest` | Noticias (publicación y notificación) y servicios del mapa. |
| `Entidad/PanelEntidadTest` | Panel institucional: datos, logo, reportes, estadísticas y auditoría. |
| `FlujoCompletoTest` | Ciclo de vida completo de un reporte entre ciudadano, administración y entidad. |

## Antes de subir un cambio

1. `php artisan test` debe pasar completo.
2. `./vendor/bin/pint` para dejar el formato consistente.
3. Si cambiaste migraciones, regenera los scripts SQL ([02-BASE-DE-DATOS.md](02-BASE-DE-DATOS.md#regenerar-los-scripts-sql)).
4. Si cambiaste una ruta o su respuesta, actualiza `openapi.json` de esta documentación.
