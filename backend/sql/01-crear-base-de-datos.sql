-- =====================================================================
-- Buenaventura Reporta · Crear la base de datos (PostgreSQL)
-- =====================================================================
-- Ejecútalo conectado a la base "postgres" con un superusuario
-- (normalmente el usuario postgres que creaste al instalar PostgreSQL).
--
--   psql -U postgres -f 01-crear-base-de-datos.sql
--
-- En pgAdmin: abre el Query Tool sobre la base "postgres", pega este
-- script y ejecútalo (F5).
-- =====================================================================

-- Opcional: usuario propio para la aplicación en lugar de "postgres".
-- Si lo usas, pon estos mismos datos en DB_USERNAME y DB_PASSWORD del .env.
-- CREATE ROLE buenaventura WITH LOGIN PASSWORD 'cambia-esta-contrasena';

CREATE DATABASE buenaventura_reporta
    WITH ENCODING = 'UTF8'
    TEMPLATE = template0;

-- Si creaste el usuario opcional, dale la propiedad de la base:
-- ALTER DATABASE buenaventura_reporta OWNER TO buenaventura;
