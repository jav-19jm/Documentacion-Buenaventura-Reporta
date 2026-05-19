# 07 — Componentes Funcionales (`components/`)

## 📁 Estructura

```
src/app/components/
├── ReportsMap.tsx           # Mapa interactivo de reportes con Leaflet
├── NotificationBell.tsx     # Campana de notificaciones en tiempo real
├── WeatherWidget.tsx        # Widget de clima de Buenaventura
├── NewsSection.tsx          # Sección de noticias para landing/dashboard
├── CityServicesFilter.tsx   # Filtro de servicios municipales en el mapa
├── ReportCard.tsx           # Tarjeta de resumen de reporte
├── IncidentTypeSelector.tsx # Selector visual de tipo de incidencia
├── LocationPickerMap.tsx    # Mapa para seleccionar ubicación
└── ReviewsCarousel.tsx      # Carrusel de testimonios
```

---

## 🗺️ `ReportsMap.tsx` (25.4 KB)

**Componente principal del mapa interactivo.** Renderiza reportes y servicios municipales como markers sobre un mapa OpenStreetMap.

### Dependencias clave
- `react-leaflet`: `MapContainer`, `TileLayer`, `Marker`, `Popup`
- `react-dom`: `createPortal` (para modal de perfil)
- `motion/react`: Animaciones del modal
- `src/lib/reports`: `voteReport`
- `src/lib/admin`: `getAllServices`
- `src/lib/badges`: `getUserBadgesWithDetails`
- `src/lib/notifications`: `createNotification`
- `src/hooks/useAuth`: Estado de autenticación

### Props

```typescript
interface ReportsMapProps {
  reports: Reporte[];           // Array de reportes a mostrar
  center?: [number, number];    // Centro del mapa [lat, lng]
  zoom?: number;                // Nivel de zoom inicial
  height?: string;              // Altura CSS del mapa
}
```

### Funcionalidades

1. **Markers de reportes**: Iconos customizados por categoría con colores según estado.
2. **Popup interactivo**: Al hacer clic en un marker:
   - Muestra imagen, título, descripción, categoría, estado.
   - Botones de voto positivo/negativo (llama `voteReport`).
   - Enlace al perfil del creador.
3. **Modal de perfil** (vía `createPortal` al `document.body`):
   - Carga datos del usuario desde Supabase.
   - Muestra estadísticas: reportes, solucionados, reputación.
   - Muestra insignias obtenidas (`getUserBadgesWithDetails`).
   - Formulario de denuncia que notifica a todos los administradores.
4. **Markers de servicios municipales**: Cargados de `getAllServices()`, con iconos por tipo.
5. **Integración con CityServicesFilter**: Toggle de capas de servicios.
6. **Integración con WeatherWidget**: Superpuesto sobre el mapa.

---

## 🔔 `NotificationBell.tsx` (8.5 KB)

**Campana de notificaciones** con contador de no leídas y Realtime de Supabase.

### Funciones de `src/lib/` usadas
- `getUserNotifications(userId)` — Carga inicial
- `markNotificationAsRead(id)` — Al hacer clic en una notificación
- `deleteNotification(id)` — Al eliminar

### Supabase Realtime
Se suscribe al canal `notifications_{userId}` para recibir nuevas notificaciones INSERT en la tabla `notificaciones` en tiempo real.

### Flujo de audio
Cuando llega una nueva notificación via Realtime:
1. Reproduce `/notification.mp3`.
2. Incrementa el contador de no leídas.
3. Agrega la notificación al estado local.

### UI
- Badge rojo con contador sobre el icono de campana.
- Dropdown con lista de notificaciones.
- Cada notificación muestra: icono por tipo, título, mensaje, tiempo relativo.
- Acciones: marcar como leída, eliminar.

---

## 🌤️ `WeatherWidget.tsx` (6.5 KB)

**Widget de clima** para Buenaventura usando la API de Open-Meteo.

### API consumida
```
https://api.open-meteo.com/v1/forecast?latitude=3.88&longitude=-77.04
```

### Datos mostrados
- Temperatura actual
- Velocidad del viento
- Humedad
- Código de clima → icono/descripción

---

## 📰 `NewsSection.tsx` (8.2 KB)

**Sección de noticias** que muestra noticias publicadas.

### Funciones de `src/lib/` usadas
- `getPublicNews()` — Obtiene noticias con `esta_publicada = true`

### Características
- Grid responsive de tarjetas de noticias.
- Imagen de portada, título, extracto, fecha.
- Entidad que publicó la noticia.
- Animaciones de entrada con Motion.

---

## 🏥 `CityServicesFilter.tsx` (7.5 KB)

**Panel de filtros** para servicios municipales en el mapa.

### Funciones de `src/lib/` usadas
- `SERVICE_TYPES` de `service-types.ts` — Catálogo de tipos

### Funcionalidad
- Checkboxes para activar/desactivar capas de servicios por tipo.
- Cada tipo tiene icono y color diferente.
- Se comunica con `ReportsMap` via props para filtrar markers visibles.

---

## 📋 `ReportCard.tsx` (2.9 KB)

**Tarjeta compacta** para listar reportes en dashboards.

### Props
Recibe un objeto `Reporte` y muestra:
- Título, categoría (badge), estado (badge con color).
- Fecha relativa.
- Contadores de votos.

---

## 🔥 `IncidentTypeSelector.tsx` (3.5 KB)

**Selector visual** de tipo de incidencia para el formulario de creación de reportes.

### Categorías disponibles
`alumbrado`, `basura`, `transporte`, `agua`, `vias`, `seguridad`, `salud`

Cada categoría tiene un icono y color distintivo. Al seleccionar, emite el valor via `onChange`.

---

## 📍 `LocationPickerMap.tsx` (2.5 KB)

**Mini mapa** para seleccionar una ubicación al crear un reporte.

### Props
```typescript
{
  onLocationSelect: (lat: number, lng: number) => void;
  initialPosition?: [number, number];
}
```

### Comportamiento
- Mapa Leaflet centrado en Buenaventura.
- Click para colocar un marker.
- Emite coordenadas via `onLocationSelect`.

---

## 💬 `ReviewsCarousel.tsx` (3.5 KB)

**Carrusel de testimonios** para la landing page.

### Contenido
Testimonios de ciudadanos con:
- Avatar (iniciales), nombre, cargo/rol.
- Texto del testimonio.
- Estrellas de calificación.

Usa animaciones de Motion para transiciones suaves entre slides.
