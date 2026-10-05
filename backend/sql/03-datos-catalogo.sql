-- =====================================================================
-- Buenaventura Reporta · Datos base del catálogo (PostgreSQL)
-- =====================================================================
-- Generado el 2026-10-05 a partir de database/seeders/CatalogoSeeder.php:
-- 6 entidades, 7 categorías de incidencia y 5 insignias.
--
-- Equivale a "php artisan db:seed --class=CatalogoSeeder". Ejecútalo
-- después de 02-esquema.sql. NO crea el usuario administrador: para eso
-- usa "php artisan db:seed" (toma ADMIN_EMAIL y ADMIN_PASSWORD del .env).
-- =====================================================================

BEGIN;

--
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Data for Name: entidades; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.entidades (id, nombre, slug, descripcion, tipo, email, telefono, color, logo_url, sitio_web, esta_activa, fecha_creacion, fecha_actualizacion) VALUES ('01a10dc7-3b3c-70dd-baf3-373a5b01b43a', 'Empresa de Aseo Municipal', 'aseo', 'Recolección de residuos y limpieza de espacios públicos.', 'ambiente', NULL, NULL, '#16a34a', NULL, NULL, true, '2026-10-05 20:35:23-05', '2026-10-05 20:35:23-05');
INSERT INTO public.entidades (id, nombre, slug, descripcion, tipo, email, telefono, color, logo_url, sitio_web, esta_activa, fecha_creacion, fecha_actualizacion) VALUES ('01a10dc7-3b43-72cf-b6b0-a2ef159506a5', 'Secretaría de Movilidad', 'movilidad', 'Semaforización, señalización y tránsito.', 'infraestructura', NULL, NULL, '#2563eb', NULL, NULL, true, '2026-10-05 20:35:23-05', '2026-10-05 20:35:23-05');
INSERT INTO public.entidades (id, nombre, slug, descripcion, tipo, email, telefono, color, logo_url, sitio_web, esta_activa, fecha_creacion, fecha_actualizacion) VALUES ('01a10dc7-3b45-725a-b274-dd52da65cdc7', 'Acueducto Municipal', 'acueducto', 'Suministro de agua potable y alcantarillado.', 'servicios-publicos', NULL, NULL, '#0891b2', NULL, NULL, true, '2026-10-05 20:35:23-05', '2026-10-05 20:35:23-05');
INSERT INTO public.entidades (id, nombre, slug, descripcion, tipo, email, telefono, color, logo_url, sitio_web, esta_activa, fecha_creacion, fecha_actualizacion) VALUES ('01a10dc7-3b47-7246-b273-b94a939fd0cb', 'Secretaría de Obras Públicas', 'obras', 'Vías, alumbrado público e infraestructura urbana.', 'infraestructura', NULL, NULL, '#ea580c', NULL, NULL, true, '2026-10-05 20:35:23-05', '2026-10-05 20:35:23-05');
INSERT INTO public.entidades (id, nombre, slug, descripcion, tipo, email, telefono, color, logo_url, sitio_web, esta_activa, fecha_creacion, fecha_actualizacion) VALUES ('01a10dc7-3b48-703a-ab90-68800f8604d4', 'Policía Nacional', 'policia', 'Seguridad ciudadana y convivencia.', 'seguridad', NULL, NULL, '#4f46e5', NULL, NULL, true, '2026-10-05 20:35:23-05', '2026-10-05 20:35:23-05');
INSERT INTO public.entidades (id, nombre, slug, descripcion, tipo, email, telefono, color, logo_url, sitio_web, esta_activa, fecha_creacion, fecha_actualizacion) VALUES ('01a10dc7-3b49-7049-9e15-f5e2de7c1ef0', 'Cuerpo de Bomberos', 'bomberos', 'Atención de incendios y emergencias.', 'seguridad', NULL, NULL, '#dc2626', NULL, NULL, true, '2026-10-05 20:35:23-05', '2026-10-05 20:35:23-05');

--
-- Data for Name: categorias_reportes; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.categorias_reportes (id, id_entidad, nombre, icono, color, descripcion, esta_activa, fecha_creacion) VALUES ('01a10dc7-3b4e-7131-a6ac-eb774c897fad', '01a10dc7-3b47-7246-b273-b94a939fd0cb', 'Luminaria dañada', 'lightbulb', 'text-yellow-600', NULL, true, '2026-10-05 20:35:23-05');
INSERT INTO public.categorias_reportes (id, id_entidad, nombre, icono, color, descripcion, esta_activa, fecha_creacion) VALUES ('01a10dc7-3b50-7341-971d-0e30ea03be35', '01a10dc7-3b3c-70dd-baf3-373a5b01b43a', 'Basura en vía pública', 'trash', 'text-green-600', NULL, true, '2026-10-05 20:35:23-05');
INSERT INTO public.categorias_reportes (id, id_entidad, nombre, icono, color, descripcion, esta_activa, fecha_creacion) VALUES ('01a10dc7-3b51-70ee-9a4d-c79e1f775d71', '01a10dc7-3b43-72cf-b6b0-a2ef159506a5', 'Semáforo dañado', 'traffic-cone', 'text-orange-600', NULL, true, '2026-10-05 20:35:23-05');
INSERT INTO public.categorias_reportes (id, id_entidad, nombre, icono, color, descripcion, esta_activa, fecha_creacion) VALUES ('01a10dc7-3b52-7225-bc80-90be014368bc', '01a10dc7-3b45-725a-b274-dd52da65cdc7', 'Fuga de agua', 'droplet', 'text-blue-600', NULL, true, '2026-10-05 20:35:23-05');
INSERT INTO public.categorias_reportes (id, id_entidad, nombre, icono, color, descripcion, esta_activa, fecha_creacion) VALUES ('01a10dc7-3b55-7225-b4b1-a62fd311755d', '01a10dc7-3b49-7049-9e15-f5e2de7c1ef0', 'Incendio', 'flame', 'text-red-600', NULL, true, '2026-10-05 20:35:23-05');
INSERT INTO public.categorias_reportes (id, id_entidad, nombre, icono, color, descripcion, esta_activa, fecha_creacion) VALUES ('01a10dc7-3b57-71aa-a45f-4a21beb0c6cc', '01a10dc7-3b48-703a-ab90-68800f8604d4', 'Alteración del orden público', 'alert-triangle', 'text-purple-600', NULL, true, '2026-10-05 20:35:23-05');
INSERT INTO public.categorias_reportes (id, id_entidad, nombre, icono, color, descripcion, esta_activa, fecha_creacion) VALUES ('01a10dc7-3b59-72ca-adc7-7c095d538bef', '01a10dc7-3b47-7246-b273-b94a939fd0cb', 'Hueco en la vía', 'hard-hat', 'text-orange-600', NULL, true, '2026-10-05 20:35:23-05');

--
-- Data for Name: insignias; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.insignias (id, nombre, descripcion, icono, requisito_texto) VALUES ('01a10dc7-3b5d-717e-afdf-3ce6c4de91dc', 'Primer Reporte', 'Creaste tu primer reporte.', '🎯', 'Crear 1 reporte');
INSERT INTO public.insignias (id, nombre, descripcion, icono, requisito_texto) VALUES ('01a10dc7-3b5e-7089-b971-7e2502138c72', '10 Reportes', 'Ciudadano comprometido.', '📣', 'Crear 10 reportes');
INSERT INTO public.insignias (id, nombre, descripcion, icono, requisito_texto) VALUES ('01a10dc7-3b5f-72ca-a18d-a7ac7f03e474', '50 Reportes', 'Guardián de la ciudad.', '🏆', 'Crear 50 reportes');
INSERT INTO public.insignias (id, nombre, descripcion, icono, requisito_texto) VALUES ('01a10dc7-3b60-70db-a83c-ce634c4ad991', 'Solucionador', 'Uno de tus reportes fue resuelto.', '✅', 'Tener 1 reporte resuelto');
INSERT INTO public.insignias (id, nombre, descripcion, icono, requisito_texto) VALUES ('01a10dc7-3b61-7326-952c-9c4f60f1399f', 'Embajador', 'La comunidad valora tus aportes.', '⭐', 'Alcanzar 100 puntos de reputación');

--
--

COMMIT;
