# 02 — Infraestructura y Base de Datos

## 🏗️ Arquitectura General

[![](https://mermaid.ink/img/pako:eNp1kl1vmzAUhv-K5d5sGm2MQyigqVK-aDftoh3ZKg16YeAQUMBGxkzrov73GpNWTNF8xTl-3vd8mCPORA44wHvJ2hLtVglH-nR9OiYSHErBFfAcfYjulx8TPALDWcbfgWUKLdv2cypnNz8rBegT2kVP6PLyBq3iTmazukpn5nbNWoZyQBHI31VWie5p4mQEayMohTh0o6TvYNmr8gzcGJC17SwTTSs4cHVS_PiiGwh7rv05q-Gthm4_4WeTrVh2GAfrW5ayDv6ZbhsPtU_tgnH_-rjT9tuGVfWkpzC-F53aS4gevhnMdpBiac2mE97GkRKS7UcjB6W9rq2mxN2wzVpVzYg8QhqJgTkfYWWWsJ0G4TS4HYP1FNuY4O59C-q5Br3Noqrr4MImqe_ZViZqIYOLoiimUHiC5qlHC_c_0PYEFQsfSDqBsKX_rCrHgZI9WLgBqbenQ3wc5AlWJTSQ4EB_5kwehgd40ZqW8V9CNG8yKfp9iYOC1Z2O-jZnCjYV0w_ZvGel3hDItei5woHjGg8cHPEfHMzJ9RWlZOF5LqWuTx0LP-PA9qnOuuSaUGo7HiHui4X_mqrkyp0Tm_rOwl1QQjx99QqzZu88?type=png)](https://mermaid.live/edit#pako:eNp1kl1vmzAUhv-K5d5sGm2MQyigqVK-aDftoh3ZKg16YeAQUMBGxkzrov73GpNWTNF8xTl-3vd8mCPORA44wHvJ2hLtVglH-nR9OiYSHErBFfAcfYjulx8TPALDWcbfgWUKLdv2cypnNz8rBegT2kVP6PLyBq3iTmazukpn5nbNWoZyQBHI31VWie5p4mQEayMohTh0o6TvYNmr8gzcGJC17SwTTSs4cHVS_PiiGwh7rv05q-Gthm4_4WeTrVh2GAfrW5ayDv6ZbhsPtU_tgnH_-rjT9tuGVfWkpzC-F53aS4gevhnMdpBiac2mE97GkRKS7UcjB6W9rq2mxN2wzVpVzYg8QhqJgTkfYWWWsJ0G4TS4HYP1FNuY4O59C-q5Br3Noqrr4MImqe_ZViZqIYOLoiimUHiC5qlHC_c_0PYEFQsfSDqBsKX_rCrHgZI9WLgBqbenQ3wc5AlWJTSQ4EB_5kwehgd40ZqW8V9CNG8yKfp9iYOC1Z2O-jZnCjYV0w_ZvGel3hDItei5woHjGg8cHPEfHMzJ9RWlZOF5LqWuTx0LP-PA9qnOuuSaUGo7HiHui4X_mqrkyp0Tm_rOwl1QQjx99QqzZu88)

---

## 📊 Diagrama Entidad-Relación

```mermaid
erDiagram
    perfiles ||--o{ reportes : "crea (id_usuario)"
    perfiles ||--o{ mensajes : "envía (id_remitente)"
    perfiles ||--o{ notificaciones : "recibe (id_usuario)"
    perfiles ||--o{ votos_reportes : "vota (id_usuario)"
    perfiles ||--o{ insignias_usuarios : "obtiene (id_usuario)"
    perfiles ||--o{ historial_reportes : "genera (id_usuario)"
    perfiles ||--o{ usuarios_entidades : "pertenece (id_usuario)"

    entidades ||--o{ reportes : "se asigna (id_entidad)"
    entidades ||--o{ noticias : "publica (id_entidad)"
    entidades ||--o{ categorias_reportes : "define (id_entidad)"
    entidades ||--o{ actividad_entidades : "registra (id_entidad)"
    entidades ||--o{ usuarios_entidades : "agrupa (id_entidad)"

    reportes ||--o{ mensajes : "tiene (id_reporte)"
    reportes ||--o{ votos_reportes : "recibe (id_reporte)"
    reportes ||--o{ historial_reportes : "registra (id_reporte)"
    reportes ||--o{ notificaciones : "referencia (id_reporte)"

    insignias ||--o{ insignias_usuarios : "se otorga (id_insignia)"

    perfiles {
        uuid id PK
        text email UK
        text nombre_completo
        text url_avatar
        enum rol
        enum estado
        int puntuacion_reputacion
        int reportes_creados
        int reportes_resueltos
    }

    entidades {
        uuid id PK
        text nombre
        text slug UK
        enum tipo
        text email
        text color
        bool esta_activa
    }

    reportes {
        uuid id PK
        uuid id_usuario FK
        uuid id_entidad FK
        text titulo
        text descripcion
        text categoria
        text latitud
        text longitud
        enum estado
        enum prioridad
        int votos_positivos
        int votos_negativos
        bool visible
    }

    mensajes {
        uuid id PK
        uuid id_reporte FK
        uuid id_remitente FK
        text tipo_remitente
        text mensaje
    }

    notificaciones {
        uuid id PK
        uuid id_usuario FK
        uuid id_reporte FK
        enum tipo
        text titulo
        text mensaje
        bool esta_leida
    }

    insignias {
        uuid id PK
        text nombre UK
        text icono
        text requisito_texto
    }

    insignias_usuarios {
        uuid id PK
        uuid id_usuario FK
        uuid id_insignia FK
        timestamp fecha_obtencion
    }
```

---

## 📋 Detalle de Tablas

### 1. `perfiles`
> Enlazada 1:1 con `auth.users` vía FK en `id`.

| Columna | Tipo | Default | Descripción |
|---|---|---|---|
| `id` | `uuid` PK | `uuid_generate_v4()` | ID del usuario (=auth.users.id) |
| `email` | `text` UNIQUE | — | Email del usuario |
| `nombre_completo` | `text` | null | Nombre visible |
| `telefono` | `text` | null | Teléfono de contacto |
| `url_avatar` | `text` | null | URL pública del avatar (bucket `avatars`) |
| `rol` | `rol_usuario` | `'ciudadano'` | `ciudadano` \| `entidad` \| `moderador` \| `administrador` |
| `estado` | `estado_usuario` | `'activo'` | `activo` \| `inactivo` \| `suspendido` |
| `puntuacion_reputacion` | `int` | 0 | Votos positivos − votos negativos acumulados |
| `votos_positivos` | `int` | 0 | Total votos positivos recibidos en reportes |
| `votos_negativos` | `int` | 0 | Total votos negativos recibidos en reportes |
| `reportes_creados` | `int` | 0 | Contador de reportes creados |
| `reportes_resueltos` | `int` | 0 | Contador de reportes marcados como resueltos |
| `motivo_bloqueo` | `text` | null | Razón del bloqueo/suspensión (si aplica) |
| `fecha_creacion` | `timestamptz` | `now()` | — |
| `fecha_actualizacion` | `timestamptz` | `now()` | — |

### 2. `entidades`
| Columna | Tipo | Default | Descripción |
|---|---|---|---|
| `id` | `uuid` PK | auto | — |
| `nombre` | `text` NOT NULL | — | Nombre de la entidad gubernamental |
| `slug` | `text` UNIQUE | — | Identificador URL-friendly |
| `descripcion` | `text` | null | — |
| `tipo` | `tipo_entidad` | — | `servicios-publicos` \| `seguridad` \| `salud` \| `infraestructura` \| `ambiente` \| `otro` |
| `email` | `text` | null | Email institucional |
| `telefono` | `text` | null | — |
| `color` | `text` | null | Color hex para branding |
| `logo_url` | `text` | null | URL pública del logo (bucket `logos`) |
| `sitio_web` | `text` | null | — |
| `esta_activa` | `bool` | true | — |

### 3. `reportes`
| Columna | Tipo | Default | Descripción |
|---|---|---|---|
| `id` | `uuid` PK | auto | — |
| `id_usuario` | `uuid` FK→perfiles | — | Ciudadano que creó el reporte |
| `id_entidad` | `uuid` FK→entidades | null | Entidad asignada para resolución |
| `titulo` | `text` NOT NULL | — | — |
| `descripcion` | `text` NOT NULL | — | — |
| `categoria` | `text` NOT NULL | — | `alumbrado` \| `basura` \| `transporte` \| `agua` \| `vias` \| `seguridad` \| `salud` |
| `direccion_ubicacion` | `text` | null | Dirección en texto libre |
| `latitud` | `text` | null | Coordenada GPS |
| `longitud` | `text` | null | Coordenada GPS |
| `url_imagen` | `text` | null | URL foto evidencia (bucket `report-images`) |
| `estado` | `estado_reporte` | `'pendiente'` | `pendiente` \| `en_revision` \| `en_proceso` \| `resuelto` \| `cancelado` |
| `prioridad` | `prioridad_reporte` | `'media'` | `baja` \| `media` \| `alta` \| `critica` |
| `votos_positivos` | `int` | 0 | — |
| `votos_negativos` | `int` | 0 | — |
| `visto` | `bool` | false | Flag para UI de "no leído" |
| `visible` | `bool` | true | Soft-delete: false oculta del mapa público |

### 4. `mensajes`
| Columna | Tipo | Default | Descripción |
|---|---|---|---|
| `id` | `uuid` PK | auto | — |
| `id_reporte` | `uuid` FK→reportes | — | Reporte al que pertenece |
| `id_remitente` | `uuid` FK→perfiles | — | Quién envió el mensaje |
| `tipo_remitente` | `text` | `'usuario'` | `usuario` \| `entidad` \| `moderador` |
| `mensaje` | `text` NOT NULL | — | Contenido del mensaje |

### 5. `notificaciones`
| Columna | Tipo | Default | Descripción |
|---|---|---|---|
| `id` | `uuid` PK | auto | — |
| `id_usuario` | `uuid` FK→perfiles | — | Destinatario |
| `id_reporte` | `uuid` FK→reportes | null | Reporte relacionado (opcional) |
| `tipo` | `tipo_notificacion` | — | `reporte_actualizado` \| `nuevo_mensaje` \| `reporte_resuelto` \| `mencion` \| `alerta_sistema` |
| `titulo` | `text` NOT NULL | — | — |
| `mensaje` | `text` NOT NULL | — | — |
| `esta_leida` | `bool` | false | — |

### 6. `votos_reportes`
| Columna | Tipo | Constraint |
|---|---|---|
| `id` | `uuid` PK | — |
| `id_reporte` | `uuid` FK→reportes | — |
| `id_usuario` | `uuid` FK→perfiles | — |
| `tipo_voto` | `text` | CHECK: `'voto_positivo'` o `'voto_negativo'` |

### 7. `insignias`
| Columna | Tipo | Descripción |
|---|---|---|
| `id` | `uuid` PK | — |
| `nombre` | `text` UNIQUE | Ej: `Primer Reporte`, `10 Reportes`, `Embajador` |
| `icono` | `text` | Emoji o código de icono |
| `requisito_texto` | `text` | Descripción del requisito para desbloquear |

### 8. `insignias_usuarios`
Tabla pivote M:N entre `perfiles` e `insignias`.

### 9. `servicios`
Puntos de interés municipal mostrados en el mapa.

| Columna | Tipo | Descripción |
|---|---|---|
| `nombre` | `text` | Nombre del servicio |
| `tipo` | `text` | `salud` \| `seguridad` \| `educacion` \| `transporte` \| `recreacion` \| `administrativo` \| `otro` |
| `latitud`/`longitud` | `text` | Coordenadas |
| `direccion` | `text` | — |
| `horario` | `text` | Horario de atención |
| `telefono` | `text` | — |
| `esta_activo` | `bool` | — |

### 10. `noticias`
| Columna | Tipo | Descripción |
|---|---|---|
| `id_entidad` | `uuid` FK | Entidad que publica |
| `titulo` | `text` | — |
| `contenido` | `text` | Cuerpo de la noticia |
| `url_imagen` | `text` | Imagen de portada (bucket `news`) |
| `esta_publicada` | `bool` | false = borrador |
| `categoria` | `text` | Categoría temática |

### 11-14. Tablas auxiliares
- **`historial_reportes`**: Log de cambios de estado en reportes.
- **`categorias_reportes`**: Categorías dinámicas con icono y color.
- **`actividad_entidades`**: Auditoría de acciones de entidades.
- **`usuarios_entidades`**: Membresía de usuarios a entidades.

---

## 🗄️ Supabase Storage (Buckets)

| Bucket | Uso | Formato |
|---|---|---|
| `avatars` | Fotos de perfil de usuarios | `{userId}-{timestamp}.{ext}` |
| `report-images` | Evidencia fotográfica de reportes | `{reportId}-{timestamp}.{ext}` |
| `news` | Imágenes de portada de noticias | `{newsId}-{timestamp}.{ext}` |
| `logos` | Logos de entidades gubernamentales | `{entityId}-{timestamp}.{ext}` |

---

## 🔄 Supabase Realtime

Se usan canales de Realtime para suscripción en vivo:

| Canal | Tabla | Evento | Componente |
|---|---|---|---|
| `admin_report_chat_{reportId}` | `mensajes` | `INSERT/UPDATE/DELETE` | `ReportsManagement` |
| `notifications_{userId}` | `notificaciones` | `INSERT` | `NotificationBell` |
| `report_chat_{reportId}` | `mensajes` | `*` | `ReportDetailPage`, `EntityReportDetail` |

---

## 🔐 Enumeraciones (ENUM en PostgreSQL)

```sql
-- Roles de usuario
CREATE TYPE rol_usuario AS ENUM ('ciudadano', 'entidad', 'moderador', 'administrador');

-- Estados de usuario
CREATE TYPE estado_usuario AS ENUM ('activo', 'inactivo', 'suspendido');

-- Estados de reporte
CREATE TYPE estado_reporte AS ENUM ('pendiente', 'en_revision', 'en_proceso', 'resuelto', 'cancelado');

-- Prioridad de reporte
CREATE TYPE prioridad_reporte AS ENUM ('baja', 'media', 'alta', 'critica');

-- Tipo de entidad
CREATE TYPE tipo_entidad AS ENUM ('servicios-publicos', 'seguridad', 'salud', 'infraestructura', 'ambiente', 'otro');

-- Tipo de notificación
CREATE TYPE tipo_notificacion AS ENUM ('reporte_actualizado', 'nuevo_mensaje', 'reporte_resuelto', 'mencion', 'alerta_sistema');
```

---

## 📐 Diagrama de Clases TypeScript

```mermaid
classDiagram
    class Perfil {
        +string id
        +string email
        +string nombre_completo
        +string url_avatar
        +RolUsuario rol
        +EstadoUsuario estado
        +number puntuacion_reputacion
        +number reportes_creados
        +number reportes_resueltos
    }

    class Reporte {
        +string id
        +string id_usuario
        +string id_entidad
        +string titulo
        +string descripcion
        +string categoria
        +string latitud
        +string longitud
        +EstadoReporte estado
        +PrioridadReporte prioridad
        +number votos_positivos
        +boolean visible
        +Entidad entidades
        +Perfil perfiles
    }

    class Entidad {
        +string id
        +string nombre
        +string slug
        +TipoEntidad tipo
        +string color
        +string logo_url
        +boolean esta_activa
    }

    class Notificacion {
        +string id
        +string id_usuario
        +string id_reporte
        +TipoNotificacion tipo
        +string titulo
        +string mensaje
        +boolean esta_leida
    }

    class Mensaje {
        +string id
        +string id_reporte
        +string id_remitente
        +string tipo_remitente
        +string mensaje
    }

    class Insignia {
        +string id
        +string nombre
        +string icono
        +string requisito_texto
    }

    class Servicio {
        +string id
        +string nombre
        +string tipo
        +string latitud
        +string longitud
        +boolean esta_activo
    }

    Perfil "1" --> "*" Reporte : crea
    Perfil "1" --> "*" Notificacion : recibe
    Perfil "1" --> "*" Mensaje : envía
    Reporte "*" --> "0..1" Entidad : asignado a
    Reporte "1" --> "*" Mensaje : contiene
    Perfil "1" --> "*" Insignia : desbloquea
```

---

## 🔀 Flujo de datos: Crear Reporte

```mermaid
sequenceDiagram
    participant U as Ciudadano
    participant FE as React App
    participant LIB as src/lib/reports
    participant SB as Supabase
    participant BADGE as src/lib/badges

    U->>FE: Completa formulario
    FE->>LIB: createReport(data)
    LIB->>SB: auth.getUser()
    SB-->>LIB: user.id
    LIB->>SB: INSERT INTO reportes
    SB-->>LIB: reporte creado
    LIB->>SB: UPDATE perfiles SET reportes_creados++
    LIB->>BADGE: checkAndGrantBadges(userId)
    BADGE->>SB: SELECT perfiles, insignias
    BADGE->>SB: INSERT insignias_usuarios (si aplica)
    LIB-->>FE: { data, error: null }
    FE-->>U: Toast + Redirect
```
