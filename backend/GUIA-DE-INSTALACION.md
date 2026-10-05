# Guía de instalación del backend (API)

> Repositorio: [`jav-19jm/Buenaventura-Reporta-API`](https://github.com/jav-19jm/Buenaventura-Reporta-API)
> Última actualización: 5 de octubre de 2026

Esta guía deja la API de **Buenaventura Reporta** funcionando en un computador con **Windows**, desde cero. Al terminar tendrás:

- La API respondiendo en `http://localhost:8000/api`.
- Una base de datos PostgreSQL `buenaventura_reporta` con todas las tablas y los datos base.
- Un usuario administrador y un ciudadano de prueba para entrar al frontend.

Tiempo estimado: 30 a 45 minutos la primera vez.

---

## Índice

1. [Requisitos](#1-requisitos)
2. [Instalar XAMPP (PHP)](#2-instalar-xampp-php)
3. [Activar las extensiones de PHP](#3-activar-las-extensiones-de-php)
4. [Instalar Composer](#4-instalar-composer)
5. [Instalar PostgreSQL](#5-instalar-postgresql)
6. [Descargar el proyecto e instalar dependencias](#6-descargar-el-proyecto-e-instalar-dependencias)
7. [Configurar el archivo `.env`](#7-configurar-el-archivo-env)
8. [Crear la base de datos](#8-crear-la-base-de-datos)
9. [Crear las tablas y los datos iniciales](#9-crear-las-tablas-y-los-datos-iniciales)
10. [Enlazar la carpeta de archivos subidos](#10-enlazar-la-carpeta-de-archivos-subidos)
11. [Levantar la API y comprobar que funciona](#11-levantar-la-api-y-comprobar-que-funciona)
12. [Usuarios de prueba y correos en desarrollo](#12-usuarios-de-prueba-y-correos-en-desarrollo)
13. [Ejecutar las pruebas automáticas](#13-ejecutar-las-pruebas-automáticas)
14. [Problemas comunes](#14-problemas-comunes)
15. [Resumen de comandos](#15-resumen-de-comandos)

---

## 1. Requisitos

| Herramienta | Versión | Para qué se usa |
|---|---|---|
| **XAMPP** | Con PHP **8.2 o superior** | Aporta PHP para Windows. Del paquete solo se usa PHP. |
| **Composer** | 2.x | Instala las dependencias PHP (Laravel, JWT…). |
| **PostgreSQL** | 16, 17 o 18 (probado con 18) | Base de datos de la API. |
| **Git** | Cualquiera reciente | Descargar el repositorio. |

> **¿Por qué XAMPP si la base es PostgreSQL?** XAMPP es la forma más sencilla de tener PHP en Windows. **No se usan su Apache ni su MySQL/MariaDB**: la API se sirve con `php artisan serve` y la base de datos es PostgreSQL. No hace falta encender nada en el panel de XAMPP.

---

## 2. Instalar XAMPP (PHP)

1. Descarga XAMPP para Windows desde [apachefriends.org](https://www.apachefriends.org/es/download.html). Elige una versión que traiga **PHP 8.2 o superior**.
2. Ejecuta el instalador. En la lista de componentes basta con dejar **PHP** (Apache y MySQL son opcionales, no los necesitas).
3. Instálalo en la ruta por defecto: `C:\xampp`.
4. Agrega PHP al `PATH` de Windows para poder usarlo desde cualquier terminal:
   1. Busca en Windows **"Editar las variables de entorno del sistema"**.
   2. Botón **Variables de entorno…** → en *Variables del sistema* selecciona `Path` → **Editar** → **Nuevo**.
   3. Escribe `C:\xampp\php` y acepta todas las ventanas.
5. **Abre una terminal nueva** (las que ya estaban abiertas no ven el cambio) y comprueba:

```bash
php -v
# PHP 8.2.12 (cli) ...
```

---

## 3. Activar las extensiones de PHP

Laravel necesita algunas extensiones que en XAMPP vienen **desactivadas**, en especial las de PostgreSQL.

1. Abre `C:\xampp\php\php.ini` con un editor de texto (VS Code, Bloc de notas…).
2. Busca cada una de estas líneas y **quítale el `;` del inicio** si lo tiene:

```ini
extension=curl
extension=fileinfo
extension=mbstring
extension=openssl
extension=pdo_pgsql   ; conexión de Laravel con PostgreSQL
extension=pgsql
extension=pdo_sqlite  ; base en memoria que usan las pruebas automáticas
extension=zip         ; acelera "composer install"
```

Ejemplo: `;extension=pdo_pgsql` debe quedar como `extension=pdo_pgsql`.

3. Guarda el archivo y comprueba en una terminal nueva:

```bash
php -m
```

En la lista deben aparecer `pdo_pgsql`, `pgsql`, `pdo_sqlite`, `mbstring`, `openssl`, `fileinfo` y `curl`.

> Si `php --ini` muestra otro archivo en *Loaded Configuration File*, edita ese.

---

## 4. Instalar Composer

1. Descarga y ejecuta **Composer-Setup.exe** desde [getcomposer.org/download](https://getcomposer.org/download/).
2. Cuando pregunte por el ejecutable de PHP, selecciona `C:\xampp\php\php.exe` (normalmente lo detecta solo).
3. Deja marcada la opción de agregar Composer al `PATH`.
4. En una terminal nueva:

```bash
composer -V
# Composer version 2.x ...
```

---

## 5. Instalar PostgreSQL

1. Descarga el instalador para Windows de [postgresql.org/download/windows](https://www.postgresql.org/download/windows/) (instalador de EDB).
2. Durante la instalación:
   - Componentes: deja marcados **PostgreSQL Server**, **pgAdmin 4** y **Command Line Tools**.
   - **Contraseña del superusuario `postgres`**: elige una y **anótala**, la vas a necesitar en el `.env`.
   - Puerto: `5432` (el que viene por defecto).
   - Locale: el predeterminado.
   - Al final puedes cerrar *Stack Builder* sin instalar nada.
3. Agrega las herramientas de línea de comandos al `PATH` (igual que en el paso 2.4), con la carpeta de tu versión:

```
C:\Program Files\PostgreSQL\18\bin
```

4. En una terminal nueva, comprueba que el servidor responde (pedirá la contraseña de `postgres`):

```bash
psql -U postgres -c "SELECT version();"
```

---

## 6. Descargar el proyecto e instalar dependencias

```bash
git clone https://github.com/jav-19jm/Buenaventura-Reporta-API.git
cd Buenaventura-Reporta-API
composer install
```

`composer install` crea la carpeta `vendor/`. Si falla diciendo que falta una extensión (`ext-...`), vuelve al [paso 3](#3-activar-las-extensiones-de-php).

> No uses `composer run setup`: además de lo que hace esta guía ejecuta `npm install` y `npm run build`, que este proyecto no necesita (la API no tiene frontend propio).

---

## 7. Configurar el archivo `.env`

1. Crea el archivo de configuración a partir de la plantilla:

```bash
copy .env.example .env
```

2. Genera las dos claves secretas (se escriben solas en el `.env`):

```bash
php artisan key:generate
php artisan jwt:secret
```

3. Abre `.env` y revisa estas variables:

| Variable | Valor en desarrollo | Para qué sirve |
|---|---|---|
| `APP_URL` | `http://localhost:8000` | URL de la API. Se usa en los enlaces de los correos y en las URL de las imágenes subidas. |
| `FRONTEND_URL` | `http://localhost:5173` | URL del frontend. Los correos enlazan a ella y es el origen permitido por CORS. |
| `CORS_ALLOWED_ORIGINS` | *(vacía)* | Solo si el frontend corre en otra URL además de `FRONTEND_URL`. Varias separadas por coma. |
| `DB_CONNECTION` | `pgsql` | No cambiar. |
| `DB_HOST` / `DB_PORT` | `127.0.0.1` / `5432` | Servidor PostgreSQL. |
| `DB_DATABASE` | `buenaventura_reporta` | Nombre de la base que crearás en el paso 8. |
| `DB_USERNAME` / `DB_PASSWORD` | `postgres` / *tu contraseña* | La contraseña que elegiste al instalar PostgreSQL. |
| `MAIL_MAILER` | `log` | Los correos se escriben en `storage/logs/laravel.log` en vez de enviarse (ver [paso 12](#12-usuarios-de-prueba-y-correos-en-desarrollo)). |
| `ADMIN_EMAIL` / `ADMIN_PASSWORD` | *(los que quieras)* | Cuenta de administrador que crea el seeder. **Cambia la contraseña por defecto.** |
| `JWT_TTL` | `60` | Minutos de vigencia del token de sesión. |
| `JWT_REFRESH_TTL` | `20160` | Minutos (2 semanas) durante los que un token vencido aún se puede renovar. |

> El `.env` **nunca** se sube a Git (está en `.gitignore`). Cada integrante tiene el suyo.

---

## 8. Crear la base de datos

Elige **una** de las tres opciones. Todas crean una base vacía llamada `buenaventura_reporta`.

### Opción A: con el script SQL (recomendada)

Desde la carpeta de esta documentación:

```bash
psql -U postgres -f backend/sql/01-crear-base-de-datos.sql
```

El script [`sql/01-crear-base-de-datos.sql`](sql/01-crear-base-de-datos.sql) también trae comentado cómo crear un usuario propio para la aplicación en lugar de usar `postgres`.

### Opción B: con pgAdmin

1. Abre **pgAdmin 4** y conéctate al servidor con la contraseña de `postgres`.
2. Clic derecho en **Databases** → **Create** → **Database…**
3. *Database*: `buenaventura_reporta` · *Encoding* (pestaña *Definition*): `UTF8` → **Save**.

### Opción C: con una sola línea

```bash
createdb -U postgres -E UTF8 buenaventura_reporta
```

---

## 9. Crear las tablas y los datos iniciales

Otra vez, elige **una** opción.

### Opción A: con las migraciones de Laravel (recomendada)

Desde la carpeta del proyecto `Buenaventura-Reporta-API`:

```bash
php artisan migrate --seed
```

Esto:

1. Ejecuta las 10 migraciones de `database/migrations` y crea todas las tablas.
2. Ejecuta `DatabaseSeeder`, que crea:
   - **Catálogo** (`CatalogoSeeder`): 6 entidades, 7 categorías de incidencia y 5 insignias.
   - **Administrador** con `ADMIN_EMAIL` / `ADMIN_PASSWORD` del `.env`.
   - Solo si `APP_ENV=local`: un **ciudadano de prueba**, 5 servicios del mapa, 2 noticias y reportes de ejemplo (`DatosDemoSeeder`).

Los seeders se pueden repetir sin duplicar datos.

### Opción B: con los scripts SQL

Útil si quieres crear las tablas desde pgAdmin (*Query Tool*) o si no puedes ejecutar Artisan contra la base. Desde la carpeta de esta documentación:

```bash
psql -U postgres -d buenaventura_reporta -f backend/sql/02-esquema.sql
psql -U postgres -d buenaventura_reporta -f backend/sql/03-datos-catalogo.sql
```

| Script | Qué hace |
|---|---|
| [`02-esquema.sql`](sql/02-esquema.sql) | Crea todas las tablas, índices y llaves foráneas, y registra las 10 migraciones como aplicadas (así `php artisan migrate` no intenta crearlas otra vez). |
| [`03-datos-catalogo.sql`](sql/03-datos-catalogo.sql) | Inserta las 6 entidades, 7 categorías y 5 insignias. |

En pgAdmin: clic derecho sobre la base `buenaventura_reporta` → **Query Tool** → abre el archivo (ícono de carpeta) → **Execute** (F5). Primero `02`, luego `03`.

Los scripts **no crean usuarios** (no se guardan contraseñas en SQL). Después ejecuta, desde el proyecto:

```bash
php artisan db:seed
```

> Las migraciones son la fuente de verdad. Si alguien agrega una migración, los scripts SQL quedan desactualizados hasta que se regeneren (ver [02-BASE-DE-DATOS.md](02-BASE-DE-DATOS.md#regenerar-los-scripts-sql)).

### Comprobar que quedó bien

```bash
php artisan migrate:status
```

Las 10 migraciones deben aparecer como **Ran**.

---

## 10. Enlazar la carpeta de archivos subidos

Las fotos de los reportes, avatares, logos e imágenes de noticias se guardan en `storage/app/public` y se sirven en `http://localhost:8000/storage/...`. Para eso hace falta un enlace simbólico:

```bash
php artisan storage:link
```

**Si te saltas este paso, las imágenes se suben bien pero se ven rotas en el frontend.**

> En Windows, si el comando falla por permisos, abre la terminal **como administrador** o activa el *Modo de desarrollador* de Windows.

---

## 11. Levantar la API y comprobar que funciona

```bash
php artisan serve
```

Deja esa terminal abierta. Comprueba en el navegador o con curl:

```bash
curl http://localhost:8000/api/prueba
# {"mensaje":"API de Buenaventura Reporta funcionando correctamente."}

curl http://localhost:8000/api/report-categories
# [{"id":"...","nombre":"Alteración del orden público", ...}, ...]
```

Ahora puedes levantar el frontend siguiendo [su guía de instalación](../frontend/GUIA-DE-INSTALACION.md). Su `VITE_API_URL` debe ser `http://localhost:8000/api`.

---

## 12. Usuarios de prueba y correos en desarrollo

### Cuentas creadas por el seeder

| Rol | Correo | Contraseña |
|---|---|---|
| Administrador | El de `ADMIN_EMAIL` | El de `ADMIN_PASSWORD` |
| Ciudadano (solo `APP_ENV=local`) | `ciudadano@buenaventura.local` | `password` |

Las cuentas de **entidad** las crea el administrador desde el panel (pestaña *Entidades*), con su correo y contraseña. Esas cuentas no necesitan verificar el correo.

### Verificar una cuenta nueva sin enviar correos

Con `MAIL_MAILER=log`, cuando alguien se registra el correo de verificación se escribe en `storage/logs/laravel.log`. Para activar la cuenta:

1. Abre `storage/logs/laravel.log` y busca la última línea con `verify-email`.
2. Copia el enlace completo (`http://localhost:8000/api/auth/verify-email/...`) y ábrelo en el navegador.
3. Te redirige al login del frontend con el mensaje "correo verificado".

El enlace de recuperación de contraseña aparece igual, con la ruta `/reset-password?token=...`.

> El enlace de verificación es una URL firmada y vence a los **60 minutos**. El de recuperación de contraseña también vence a los 60 minutos.

### Enviar correos de verdad (opcional)

Por ejemplo, con una cuenta de Gmail y una **contraseña de aplicación** (Cuenta de Google → Seguridad → Verificación en dos pasos → Contraseñas de aplicaciones):

```dotenv
MAIL_MAILER=smtp
MAIL_HOST=smtp.gmail.com
MAIL_PORT=587
MAIL_USERNAME=tu-correo@gmail.com
MAIL_PASSWORD=la-contraseña-de-aplicación
MAIL_FROM_ADDRESS="tu-correo@gmail.com"
```

Después de cambiar el `.env`, ejecuta `php artisan config:clear`.

---

## 13. Ejecutar las pruebas automáticas

```bash
php artisan test
```

Las pruebas usan una base **SQLite en memoria** (configurada en `phpunit.xml`), así que **no tocan tu base PostgreSQL**. Solo necesitan la extensión `pdo_sqlite` del paso 3. Resultado esperado (5 de octubre de 2026): **86 pruebas aprobadas**.

Más detalle en [06-PRUEBAS.md](06-PRUEBAS.md).

---

## 14. Problemas comunes

| Mensaje o síntoma | Causa | Solución |
|---|---|---|
| `'php' no se reconoce como un comando…` | PHP no está en el `PATH` | Repite el paso 2.4 y abre una terminal **nueva**. |
| `could not find driver` al migrar | Falta `pdo_pgsql` | Actívala en `php.ini` (paso 3). |
| `password authentication failed for user "postgres"` | Contraseña incorrecta en `.env` | Corrige `DB_PASSWORD` y ejecuta `php artisan config:clear`. |
| `database "buenaventura_reporta" does not exist` | No se creó la base | Haz el paso 8. |
| `Connection refused` en el puerto 5432 | El servicio de PostgreSQL está detenido | Inícialo en *Servicios* de Windows (`postgresql-x64-18`). |
| `Secret is not set` o errores de JWT | Falta `JWT_SECRET` | `php artisan jwt:secret`. |
| `No application encryption key has been specified` | Falta `APP_KEY` | `php artisan key:generate`. |
| Las imágenes se ven rotas | Falta el enlace de `storage` | `php artisan storage:link` (paso 10). |
| El frontend muestra errores de CORS | El origen del frontend no está permitido | Revisa `FRONTEND_URL` / `CORS_ALLOWED_ORIGINS` y ejecuta `php artisan config:clear`. |
| Al iniciar sesión: "Tu correo electrónico aún no ha sido verificado" | Cuenta nueva sin verificar | Abre el enlace del log (paso 12). |
| `relation "migrations" already exists` o tablas duplicadas | Se mezclaron la opción A y la B del paso 9 | Usa solo una. Para empezar de cero: `php artisan migrate:fresh --seed` (**borra todos los datos**). |
| `Address already in use` al hacer `serve` | El puerto 8000 está ocupado | `php artisan serve --port=8001` y cambia `APP_URL` y el `VITE_API_URL` del frontend. |
| Cambié el `.env` y no pasa nada | Configuración en caché | `php artisan config:clear`. |

---

## 15. Resumen de comandos

Para quien ya tiene XAMPP, Composer y PostgreSQL instalados:

```bash
git clone https://github.com/jav-19jm/Buenaventura-Reporta-API.git
cd Buenaventura-Reporta-API
composer install
copy .env.example .env          # luego edita DB_PASSWORD y ADMIN_*
php artisan key:generate
php artisan jwt:secret
createdb -U postgres -E UTF8 buenaventura_reporta
php artisan migrate --seed
php artisan storage:link
php artisan serve
```
