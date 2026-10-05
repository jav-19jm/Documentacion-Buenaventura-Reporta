# Guía de instalación del frontend

> Repositorio: [`jav-19jm/Buenaventura-Reporta`](https://github.com/jav-19jm/Buenaventura-Reporta)
> Última actualización: 5 de octubre de 2026

Esta guía deja el frontend de **Buenaventura Reporta** (React + Vite) funcionando en tu computador y conectado a la API. Tiempo estimado: 10 minutos.

> **Antes de empezar:** el frontend no funciona solo. Necesita la API levantada en `http://localhost:8000`. Si todavía no la tienes, sigue primero la [guía de instalación del backend](../backend/GUIA-DE-INSTALACION.md).

---

## Índice

1. [Requisitos](#1-requisitos)
2. [Instalar Node.js](#2-instalar-nodejs)
3. [Descargar el proyecto e instalar dependencias](#3-descargar-el-proyecto-e-instalar-dependencias)
4. [Configurar el archivo `.env`](#4-configurar-el-archivo-env)
5. [Levantar el servidor de desarrollo](#5-levantar-el-servidor-de-desarrollo)
6. [Entrar con los usuarios de prueba](#6-entrar-con-los-usuarios-de-prueba)
7. [Scripts disponibles](#7-scripts-disponibles)
8. [Compilar y desplegar](#8-compilar-y-desplegar)
9. [Problemas comunes](#9-problemas-comunes)

---

## 1. Requisitos

| Herramienta | Versión | Notas |
|---|---|---|
| **Node.js** | 20 o superior (LTS) | Trae `npm`. El despliegue automático usa Node 20; en desarrollo se probó con Node 22. |
| **Git** | Cualquiera reciente | Para descargar el repositorio. |
| **API de Buenaventura Reporta** | — | Corriendo en `http://localhost:8000` ([guía del backend](../backend/GUIA-DE-INSTALACION.md)). |
| Navegador | Chrome, Edge o Firefox actualizados | — |

---

## 2. Instalar Node.js

1. Descarga el instalador **LTS** para Windows desde [nodejs.org](https://nodejs.org/es).
2. Ejecútalo con las opciones por defecto (incluye `npm` y lo agrega al `PATH`).
3. En una terminal nueva:

```bash
node -v   # v20.x o superior
npm -v
```

---

## 3. Descargar el proyecto e instalar dependencias

```bash
git clone https://github.com/jav-19jm/Buenaventura-Reporta.git
cd Buenaventura-Reporta
npm install
```

`npm install` descarga las dependencias en `node_modules/` (tarda un par de minutos la primera vez).

---

## 4. Configurar el archivo `.env`

1. Crea tu archivo de configuración a partir de la plantilla:

```bash
copy .env.example .env
```

2. Revisa que apunte a la API:

```dotenv
VITE_API_URL=http://localhost:8000/api
```

| Variable | Valor en desarrollo | Descripción |
|---|---|---|
| `VITE_API_URL` | `http://localhost:8000/api` | URL base de la API, **incluyendo `/api`**. Si no se define, el código usa ese mismo valor por defecto. |

> **Importante:** Vite incrusta las variables `VITE_*` en el código al compilar, y **cualquiera puede leerlas** en el navegador. Nunca pongas contraseñas ni claves secretas en este archivo.

---

## 5. Levantar el servidor de desarrollo

Con la API ya corriendo en otra terminal (`php artisan serve`):

```bash
npm run dev
```

Abre **http://localhost:5173**. Vite recarga la página sola cada vez que guardas un archivo.

Comprobación rápida:

- La landing carga con el logo de Buenaventura Reporta.
- En **Mapa de reportes** (`/map`) aparecen los reportes de la base y el panel de filtros con conteos. Si el mapa sale vacío y aparece "No pudimos cargar los reportes", la API no está respondiendo (ver [problemas comunes](#9-problemas-comunes)).

---

## 6. Entrar con los usuarios de prueba

El seeder del backend crea estas cuentas:

| Rol | Correo | Contraseña | Panel |
|---|---|---|---|
| Administrador | El de `ADMIN_EMAIL` del `.env` del backend | El de `ADMIN_PASSWORD` | `/admin` |
| Ciudadano | `ciudadano@buenaventura.local` | `password` | `/user` |

Después de iniciar sesión, la app lleva a cada quien a su panel según su rol. Las cuentas de **entidad** se crean desde el panel de administración (pestaña *Entidades*) y entran por el mismo `/login`.

¿Te registraste con una cuenta nueva? En desarrollo el correo de verificación no se envía: el enlace queda en `storage/logs/laravel.log` del backend ([cómo usarlo](../backend/GUIA-DE-INSTALACION.md#12-usuarios-de-prueba-y-correos-en-desarrollo)).

---

## 7. Scripts disponibles

| Comando | Qué hace |
|---|---|
| `npm run dev` | Servidor de desarrollo en `http://localhost:5173`. |
| `npm run build` | Comprueba los tipos (`tsc -b`) y compila a `dist/`. Falla si hay errores de TypeScript. |
| `npm run preview` | Sirve `dist/` localmente para revisar la versión compilada. |
| `npm run typecheck` | Solo la comprobación de tipos. |
| `npm run lint` | ESLint sobre todo el proyecto. |

Antes de subir cambios, ejecuta al menos `npm run build`.

---

## 8. Compilar y desplegar

```bash
npm run build
```

Genera la carpeta `dist/` con archivos estáticos (HTML, JS, CSS, imágenes) que cualquier servidor web puede servir.

### Cosas a tener en cuenta

1. **`VITE_API_URL` se fija al compilar.** Para producción, compila con la URL pública de la API:

   ```bash
   # PowerShell
   $env:VITE_API_URL="https://api.tu-dominio.com/api"; npm run build
   ```

   o crea un `.env.production` con `VITE_API_URL=...` antes de `npm run build`.

2. **Rutas de la SPA.** El servidor debe responder `index.html` para cualquier ruta (por ejemplo `/user/map`). Para Apache ya viene `public/.htaccess`, que se copia a `dist/` al compilar. En Nginx usa `try_files $uri /index.html;`.

3. **CORS en el backend.** El dominio del frontend debe estar en `CORS_ALLOWED_ORIGINS` (o `FRONTEND_URL`) del `.env` de la API.

### Despliegue automático (GitHub Actions)

`.github/workflows/frontend-deploy.yml` compila y sube `dist/` al servidor por SSH en cada `push` a `main`. Usa los secretos del repositorio `HOST`, `USERNAME` y `SSH_KEY`.

> ⚠️ El paso *Build del frontend* **no define `VITE_API_URL`**, así que la versión desplegada apunta a `http://localhost:8000/api` y no podrá hablar con la API. Agrega un secreto `VITE_API_URL` en GitHub (Settings → Secrets and variables → Actions) y pásalo al build:
>
> ```yaml
> - name: Build del frontend
>   env:
>     CI: false
>     GENERATE_SOURCEMAP: false
>     VITE_API_URL: ${{ secrets.VITE_API_URL }}
>   run: npm run build
> ```

---

## 9. Problemas comunes

| Mensaje o síntoma | Causa | Solución |
|---|---|---|
| "No se pudo conectar con el servidor" / "No pudimos cargar los reportes" | La API no está corriendo o `VITE_API_URL` está mal | Levanta la API (`php artisan serve`) y revisa el `.env`. |
| Errores de **CORS** en la consola del navegador | El backend no permite el origen del frontend | En el `.env` del backend, `FRONTEND_URL=http://localhost:5173`; luego `php artisan config:clear`. |
| Vite arrancó en el puerto **5174** y aparecen errores de CORS | El 5173 estaba ocupado | Cierra el otro proceso o usa `npm run dev -- --port 5173 --strictPort`. También puedes agregar el puerto a `CORS_ALLOWED_ORIGINS` del backend. |
| Cambié el `.env` y no se nota | Vite lee el `.env` solo al arrancar | Detén `npm run dev` (Ctrl + C) y vuelve a ejecutarlo. |
| Las fotos de los reportes se ven rotas | Falta el enlace de `storage` en el backend | En el backend: `php artisan storage:link`. |
| "Tu correo electrónico aún no ha sido verificado" | Cuenta nueva sin verificar | Abre el enlace de verificación del log del backend. |
| Me saca de la sesión con "Sesión finalizada" | La cuenta fue suspendida o el token ya no se puede renovar | Vuelve a iniciar sesión o revisa el estado de la cuenta en el panel de administración. |
| El mapa sale gris, sin calles | Sin conexión a internet (los mapas vienen de OpenStreetMap) | Revisa la conexión. |
| `npm run build` falla con errores de TypeScript | Hay errores de tipos en el código | Corrígelos; `npm run typecheck` los lista. |
