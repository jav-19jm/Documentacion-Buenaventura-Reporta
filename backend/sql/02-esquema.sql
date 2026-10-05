-- =====================================================================
-- Buenaventura Reporta · Esquema de la base de datos (PostgreSQL)
-- =====================================================================
-- Generado el 2026-10-05 con pg_dump a partir de las migraciones de Laravel
-- (database/migrations del repo Buenaventura-Reporta-API).
--
-- LA FUENTE DE VERDAD SON LAS MIGRACIONES. Usa este script solo si no
-- puedes ejecutar "php artisan migrate" (por ejemplo, para crear las
-- tablas desde pgAdmin). Si cambian las migraciones, vuelve a generarlo
-- (ver backend/02-BASE-DE-DATOS.md, "Regenerar los scripts SQL").
--
-- Ejecútalo conectado a la base buenaventura_reporta ya creada
-- (script 01). También registra las migraciones en la tabla "migrations"
-- para que "php artisan migrate" no intente crear las tablas otra vez.
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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: actividad_entidades; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.actividad_entidades (
    id uuid NOT NULL,
    id_entidad uuid NOT NULL,
    tipo_accion character varying(50) NOT NULL,
    titulo character varying(255) NOT NULL,
    descripcion text NOT NULL,
    fecha_creacion timestamp(0) with time zone
);

--
-- Name: cache; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cache (
    key character varying(255) NOT NULL,
    value text NOT NULL,
    expiration integer NOT NULL
);

--
-- Name: cache_locks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cache_locks (
    key character varying(255) NOT NULL,
    owner character varying(255) NOT NULL,
    expiration integer NOT NULL
);

--
-- Name: categorias_reportes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.categorias_reportes (
    id uuid NOT NULL,
    id_entidad uuid,
    nombre character varying(255) NOT NULL,
    icono character varying(255),
    color character varying(255),
    descripcion text,
    esta_activa boolean DEFAULT true NOT NULL,
    fecha_creacion timestamp(0) with time zone
);

--
-- Name: entidades; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.entidades (
    id uuid NOT NULL,
    nombre character varying(255) NOT NULL,
    slug character varying(255) NOT NULL,
    descripcion text,
    tipo character varying(255) NOT NULL,
    email character varying(255),
    telefono character varying(255),
    color character varying(255),
    logo_url text,
    sitio_web character varying(255),
    esta_activa boolean DEFAULT true NOT NULL,
    fecha_creacion timestamp(0) with time zone,
    fecha_actualizacion timestamp(0) with time zone,
    CONSTRAINT entidades_tipo_check CHECK (((tipo)::text = ANY ((ARRAY['servicios-publicos'::character varying, 'seguridad'::character varying, 'salud'::character varying, 'infraestructura'::character varying, 'ambiente'::character varying, 'otro'::character varying])::text[])))
);

--
-- Name: failed_jobs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.failed_jobs (
    id bigint NOT NULL,
    uuid character varying(255) NOT NULL,
    connection text NOT NULL,
    queue text NOT NULL,
    payload text NOT NULL,
    exception text NOT NULL,
    failed_at timestamp(0) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);

--
-- Name: failed_jobs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.failed_jobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

--
-- Name: failed_jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.failed_jobs_id_seq OWNED BY public.failed_jobs.id;

--
-- Name: historial_reportes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.historial_reportes (
    id uuid NOT NULL,
    id_reporte uuid NOT NULL,
    accion character varying(255) NOT NULL,
    valor_anterior text,
    valor_nuevo text,
    id_usuario uuid,
    fecha_creacion timestamp(0) with time zone
);

--
-- Name: insignias; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.insignias (
    id uuid NOT NULL,
    nombre character varying(255) NOT NULL,
    descripcion text,
    icono character varying(255),
    requisito_texto character varying(255)
);

--
-- Name: insignias_usuarios; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.insignias_usuarios (
    id uuid NOT NULL,
    id_usuario uuid NOT NULL,
    id_insignia uuid NOT NULL,
    fecha_obtencion timestamp(0) with time zone
);

--
-- Name: job_batches; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.job_batches (
    id character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    total_jobs integer NOT NULL,
    pending_jobs integer NOT NULL,
    failed_jobs integer NOT NULL,
    failed_job_ids text NOT NULL,
    options text,
    cancelled_at integer,
    created_at integer NOT NULL,
    finished_at integer
);

--
-- Name: jobs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.jobs (
    id bigint NOT NULL,
    queue character varying(255) NOT NULL,
    payload text NOT NULL,
    attempts smallint NOT NULL,
    reserved_at integer,
    available_at integer NOT NULL,
    created_at integer NOT NULL
);

--
-- Name: jobs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.jobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

--
-- Name: jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.jobs_id_seq OWNED BY public.jobs.id;

--
-- Name: mensajes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.mensajes (
    id uuid NOT NULL,
    id_reporte uuid NOT NULL,
    id_remitente uuid NOT NULL,
    tipo_remitente character varying(255) DEFAULT 'usuario'::character varying NOT NULL,
    mensaje text NOT NULL,
    fecha_creacion timestamp(0) with time zone,
    CONSTRAINT mensajes_tipo_remitente_check CHECK (((tipo_remitente)::text = ANY ((ARRAY['usuario'::character varying, 'entidad'::character varying, 'moderador'::character varying])::text[])))
);

--
-- Name: migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.migrations (
    id integer NOT NULL,
    migration character varying(255) NOT NULL,
    batch integer NOT NULL
);

--
-- Name: migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

--
-- Name: migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.migrations_id_seq OWNED BY public.migrations.id;

--
-- Name: noticias; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.noticias (
    id uuid NOT NULL,
    id_entidad uuid,
    titulo character varying(255) NOT NULL,
    contenido text NOT NULL,
    url_imagen text,
    categoria character varying(255),
    esta_publicada boolean DEFAULT false NOT NULL,
    fecha_publicacion timestamp(0) with time zone,
    fecha_creacion timestamp(0) with time zone,
    fecha_actualizacion timestamp(0) with time zone
);

--
-- Name: notificaciones; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.notificaciones (
    id uuid NOT NULL,
    id_usuario uuid NOT NULL,
    id_reporte uuid,
    tipo character varying(255),
    titulo character varying(255) NOT NULL,
    mensaje text NOT NULL,
    esta_leida boolean DEFAULT false NOT NULL,
    fecha_creacion timestamp(0) with time zone,
    CONSTRAINT notificaciones_tipo_check CHECK (((tipo)::text = ANY ((ARRAY['reporte_actualizado'::character varying, 'nuevo_mensaje'::character varying, 'reporte_resuelto'::character varying, 'mencion'::character varying, 'alerta_sistema'::character varying])::text[])))
);

--
-- Name: password_reset_tokens; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.password_reset_tokens (
    email character varying(255) NOT NULL,
    token character varying(255) NOT NULL,
    created_at timestamp(0) without time zone
);

--
-- Name: reportes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.reportes (
    id uuid NOT NULL,
    id_usuario uuid NOT NULL,
    id_entidad uuid,
    titulo character varying(255) NOT NULL,
    descripcion text NOT NULL,
    categoria character varying(255) NOT NULL,
    direccion_ubicacion character varying(255),
    latitud numeric(10,7),
    longitud numeric(10,7),
    url_imagen text,
    estado character varying(255) DEFAULT 'pendiente'::character varying NOT NULL,
    prioridad character varying(255) DEFAULT 'media'::character varying NOT NULL,
    votos_positivos integer DEFAULT 0 NOT NULL,
    votos_negativos integer DEFAULT 0 NOT NULL,
    visto boolean DEFAULT false NOT NULL,
    visible boolean DEFAULT true NOT NULL,
    fecha_creacion timestamp(0) with time zone,
    fecha_actualizacion timestamp(0) with time zone,
    CONSTRAINT reportes_estado_check CHECK (((estado)::text = ANY ((ARRAY['pendiente'::character varying, 'en_revision'::character varying, 'en_proceso'::character varying, 'resuelto'::character varying, 'cancelado'::character varying])::text[]))),
    CONSTRAINT reportes_prioridad_check CHECK (((prioridad)::text = ANY ((ARRAY['baja'::character varying, 'media'::character varying, 'alta'::character varying, 'critica'::character varying])::text[])))
);

--
-- Name: servicios; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.servicios (
    id uuid NOT NULL,
    nombre character varying(255) NOT NULL,
    descripcion text,
    tipo character varying(255) NOT NULL,
    latitud numeric(10,7) NOT NULL,
    longitud numeric(10,7) NOT NULL,
    direccion character varying(255),
    horario character varying(255),
    telefono character varying(255),
    esta_activo boolean DEFAULT true NOT NULL,
    fecha_creacion timestamp(0) with time zone,
    fecha_actualizacion timestamp(0) with time zone
);

--
-- Name: sessions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sessions (
    id character varying(255) NOT NULL,
    user_id uuid,
    ip_address character varying(45),
    user_agent text,
    payload text NOT NULL,
    last_activity integer NOT NULL
);

--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id uuid NOT NULL,
    email character varying(255) NOT NULL,
    email_verified_at timestamp(0) without time zone,
    password character varying(255) NOT NULL,
    nombre_completo character varying(255),
    telefono character varying(255),
    url_avatar text,
    rol character varying(255) DEFAULT 'ciudadano'::character varying NOT NULL,
    estado character varying(255) DEFAULT 'activo'::character varying NOT NULL,
    motivo_bloqueo text,
    puntuacion_reputacion integer DEFAULT 0 NOT NULL,
    votos_positivos integer DEFAULT 0 NOT NULL,
    votos_negativos integer DEFAULT 0 NOT NULL,
    reportes_creados integer DEFAULT 0 NOT NULL,
    reportes_resueltos integer DEFAULT 0 NOT NULL,
    id_entidad uuid,
    remember_token character varying(100),
    fecha_creacion timestamp(0) with time zone,
    fecha_actualizacion timestamp(0) with time zone,
    CONSTRAINT users_estado_check CHECK (((estado)::text = ANY ((ARRAY['activo'::character varying, 'inactivo'::character varying, 'suspendido'::character varying])::text[]))),
    CONSTRAINT users_rol_check CHECK (((rol)::text = ANY ((ARRAY['ciudadano'::character varying, 'entidad'::character varying, 'moderador'::character varying, 'administrador'::character varying])::text[])))
);

--
-- Name: votos_reportes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.votos_reportes (
    id uuid NOT NULL,
    id_reporte uuid NOT NULL,
    id_usuario uuid NOT NULL,
    tipo_voto character varying(255) NOT NULL,
    fecha_creacion timestamp(0) with time zone,
    CONSTRAINT votos_reportes_tipo_voto_check CHECK (((tipo_voto)::text = ANY ((ARRAY['voto_positivo'::character varying, 'voto_negativo'::character varying])::text[])))
);

--
-- Name: failed_jobs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.failed_jobs ALTER COLUMN id SET DEFAULT nextval('public.failed_jobs_id_seq'::regclass);

--
-- Name: jobs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.jobs ALTER COLUMN id SET DEFAULT nextval('public.jobs_id_seq'::regclass);

--
-- Name: migrations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.migrations ALTER COLUMN id SET DEFAULT nextval('public.migrations_id_seq'::regclass);

--
-- Name: actividad_entidades actividad_entidades_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.actividad_entidades
    ADD CONSTRAINT actividad_entidades_pkey PRIMARY KEY (id);

--
-- Name: cache_locks cache_locks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cache_locks
    ADD CONSTRAINT cache_locks_pkey PRIMARY KEY (key);

--
-- Name: cache cache_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cache
    ADD CONSTRAINT cache_pkey PRIMARY KEY (key);

--
-- Name: categorias_reportes categorias_reportes_nombre_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categorias_reportes
    ADD CONSTRAINT categorias_reportes_nombre_unique UNIQUE (nombre);

--
-- Name: categorias_reportes categorias_reportes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categorias_reportes
    ADD CONSTRAINT categorias_reportes_pkey PRIMARY KEY (id);

--
-- Name: entidades entidades_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.entidades
    ADD CONSTRAINT entidades_pkey PRIMARY KEY (id);

--
-- Name: entidades entidades_slug_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.entidades
    ADD CONSTRAINT entidades_slug_unique UNIQUE (slug);

--
-- Name: failed_jobs failed_jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.failed_jobs
    ADD CONSTRAINT failed_jobs_pkey PRIMARY KEY (id);

--
-- Name: failed_jobs failed_jobs_uuid_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.failed_jobs
    ADD CONSTRAINT failed_jobs_uuid_unique UNIQUE (uuid);

--
-- Name: historial_reportes historial_reportes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.historial_reportes
    ADD CONSTRAINT historial_reportes_pkey PRIMARY KEY (id);

--
-- Name: insignias insignias_nombre_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.insignias
    ADD CONSTRAINT insignias_nombre_unique UNIQUE (nombre);

--
-- Name: insignias insignias_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.insignias
    ADD CONSTRAINT insignias_pkey PRIMARY KEY (id);

--
-- Name: insignias_usuarios insignias_usuarios_id_usuario_id_insignia_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.insignias_usuarios
    ADD CONSTRAINT insignias_usuarios_id_usuario_id_insignia_unique UNIQUE (id_usuario, id_insignia);

--
-- Name: insignias_usuarios insignias_usuarios_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.insignias_usuarios
    ADD CONSTRAINT insignias_usuarios_pkey PRIMARY KEY (id);

--
-- Name: job_batches job_batches_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.job_batches
    ADD CONSTRAINT job_batches_pkey PRIMARY KEY (id);

--
-- Name: jobs jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.jobs
    ADD CONSTRAINT jobs_pkey PRIMARY KEY (id);

--
-- Name: mensajes mensajes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mensajes
    ADD CONSTRAINT mensajes_pkey PRIMARY KEY (id);

--
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);

--
-- Name: noticias noticias_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.noticias
    ADD CONSTRAINT noticias_pkey PRIMARY KEY (id);

--
-- Name: notificaciones notificaciones_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notificaciones
    ADD CONSTRAINT notificaciones_pkey PRIMARY KEY (id);

--
-- Name: password_reset_tokens password_reset_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.password_reset_tokens
    ADD CONSTRAINT password_reset_tokens_pkey PRIMARY KEY (email);

--
-- Name: reportes reportes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reportes
    ADD CONSTRAINT reportes_pkey PRIMARY KEY (id);

--
-- Name: servicios servicios_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.servicios
    ADD CONSTRAINT servicios_pkey PRIMARY KEY (id);

--
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);

--
-- Name: users users_email_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_unique UNIQUE (email);

--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);

--
-- Name: votos_reportes votos_reportes_id_reporte_id_usuario_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.votos_reportes
    ADD CONSTRAINT votos_reportes_id_reporte_id_usuario_unique UNIQUE (id_reporte, id_usuario);

--
-- Name: votos_reportes votos_reportes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.votos_reportes
    ADD CONSTRAINT votos_reportes_pkey PRIMARY KEY (id);

--
-- Name: actividad_entidades_id_entidad_fecha_creacion_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX actividad_entidades_id_entidad_fecha_creacion_index ON public.actividad_entidades USING btree (id_entidad, fecha_creacion);

--
-- Name: cache_expiration_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX cache_expiration_index ON public.cache USING btree (expiration);

--
-- Name: cache_locks_expiration_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX cache_locks_expiration_index ON public.cache_locks USING btree (expiration);

--
-- Name: jobs_queue_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX jobs_queue_index ON public.jobs USING btree (queue);

--
-- Name: mensajes_fecha_creacion_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX mensajes_fecha_creacion_index ON public.mensajes USING btree (fecha_creacion);

--
-- Name: noticias_esta_publicada_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX noticias_esta_publicada_index ON public.noticias USING btree (esta_publicada);

--
-- Name: notificaciones_id_usuario_fecha_creacion_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX notificaciones_id_usuario_fecha_creacion_index ON public.notificaciones USING btree (id_usuario, fecha_creacion);

--
-- Name: reportes_categoria_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX reportes_categoria_index ON public.reportes USING btree (categoria);

--
-- Name: reportes_estado_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX reportes_estado_index ON public.reportes USING btree (estado);

--
-- Name: reportes_visible_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX reportes_visible_index ON public.reportes USING btree (visible);

--
-- Name: sessions_last_activity_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sessions_last_activity_index ON public.sessions USING btree (last_activity);

--
-- Name: sessions_user_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sessions_user_id_index ON public.sessions USING btree (user_id);

--
-- Name: users_id_entidad_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX users_id_entidad_index ON public.users USING btree (id_entidad);

--
-- Name: actividad_entidades actividad_entidades_id_entidad_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.actividad_entidades
    ADD CONSTRAINT actividad_entidades_id_entidad_foreign FOREIGN KEY (id_entidad) REFERENCES public.entidades(id) ON DELETE CASCADE;

--
-- Name: categorias_reportes categorias_reportes_id_entidad_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categorias_reportes
    ADD CONSTRAINT categorias_reportes_id_entidad_foreign FOREIGN KEY (id_entidad) REFERENCES public.entidades(id) ON DELETE SET NULL;

--
-- Name: historial_reportes historial_reportes_id_reporte_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.historial_reportes
    ADD CONSTRAINT historial_reportes_id_reporte_foreign FOREIGN KEY (id_reporte) REFERENCES public.reportes(id) ON DELETE CASCADE;

--
-- Name: historial_reportes historial_reportes_id_usuario_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.historial_reportes
    ADD CONSTRAINT historial_reportes_id_usuario_foreign FOREIGN KEY (id_usuario) REFERENCES public.users(id) ON DELETE SET NULL;

--
-- Name: insignias_usuarios insignias_usuarios_id_insignia_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.insignias_usuarios
    ADD CONSTRAINT insignias_usuarios_id_insignia_foreign FOREIGN KEY (id_insignia) REFERENCES public.insignias(id) ON DELETE CASCADE;

--
-- Name: insignias_usuarios insignias_usuarios_id_usuario_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.insignias_usuarios
    ADD CONSTRAINT insignias_usuarios_id_usuario_foreign FOREIGN KEY (id_usuario) REFERENCES public.users(id) ON DELETE CASCADE;

--
-- Name: mensajes mensajes_id_remitente_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mensajes
    ADD CONSTRAINT mensajes_id_remitente_foreign FOREIGN KEY (id_remitente) REFERENCES public.users(id) ON DELETE CASCADE;

--
-- Name: mensajes mensajes_id_reporte_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mensajes
    ADD CONSTRAINT mensajes_id_reporte_foreign FOREIGN KEY (id_reporte) REFERENCES public.reportes(id) ON DELETE CASCADE;

--
-- Name: noticias noticias_id_entidad_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.noticias
    ADD CONSTRAINT noticias_id_entidad_foreign FOREIGN KEY (id_entidad) REFERENCES public.entidades(id) ON DELETE SET NULL;

--
-- Name: notificaciones notificaciones_id_reporte_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notificaciones
    ADD CONSTRAINT notificaciones_id_reporte_foreign FOREIGN KEY (id_reporte) REFERENCES public.reportes(id) ON DELETE CASCADE;

--
-- Name: notificaciones notificaciones_id_usuario_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notificaciones
    ADD CONSTRAINT notificaciones_id_usuario_foreign FOREIGN KEY (id_usuario) REFERENCES public.users(id) ON DELETE CASCADE;

--
-- Name: reportes reportes_id_entidad_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reportes
    ADD CONSTRAINT reportes_id_entidad_foreign FOREIGN KEY (id_entidad) REFERENCES public.entidades(id) ON DELETE SET NULL;

--
-- Name: reportes reportes_id_usuario_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reportes
    ADD CONSTRAINT reportes_id_usuario_foreign FOREIGN KEY (id_usuario) REFERENCES public.users(id) ON DELETE CASCADE;

--
-- Name: users users_id_entidad_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_id_entidad_foreign FOREIGN KEY (id_entidad) REFERENCES public.entidades(id) ON DELETE SET NULL;

--
-- Name: votos_reportes votos_reportes_id_reporte_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.votos_reportes
    ADD CONSTRAINT votos_reportes_id_reporte_foreign FOREIGN KEY (id_reporte) REFERENCES public.reportes(id) ON DELETE CASCADE;

--
-- Name: votos_reportes votos_reportes_id_usuario_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.votos_reportes
    ADD CONSTRAINT votos_reportes_id_usuario_foreign FOREIGN KEY (id_usuario) REFERENCES public.users(id) ON DELETE CASCADE;

--
--

-- ---------------------------------------------------------------------
-- Migraciones que este script deja aplicadas
-- ---------------------------------------------------------------------

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
-- Data for Name: migrations; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.migrations VALUES (1, '0001_01_01_000000_create_users_table', 1);
INSERT INTO public.migrations VALUES (2, '0001_01_01_000001_create_cache_table', 1);
INSERT INTO public.migrations VALUES (3, '0001_01_01_000002_create_jobs_table', 1);
INSERT INTO public.migrations VALUES (4, '2026_09_28_000001_create_entidades_table', 1);
INSERT INTO public.migrations VALUES (5, '2026_09_28_000002_create_categorias_reportes_table', 1);
INSERT INTO public.migrations VALUES (6, '2026_09_28_000003_create_reportes_table', 1);
INSERT INTO public.migrations VALUES (7, '2026_09_28_000004_create_notificaciones_table', 1);
INSERT INTO public.migrations VALUES (8, '2026_09_28_000005_create_insignias_tables', 1);
INSERT INTO public.migrations VALUES (9, '2026_09_28_000006_create_noticias_y_servicios_tables', 1);
INSERT INTO public.migrations VALUES (10, '2026_10_01_000001_create_actividad_entidades_table', 1);

--
-- Name: migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.migrations_id_seq', 10, true);

--
--

COMMIT;
