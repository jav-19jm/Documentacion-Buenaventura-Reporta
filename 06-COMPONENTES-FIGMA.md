# 06 — Componentes Figma (`components/figma/`)

## 📁 Estructura

```
src/app/components/figma/
└── ImageWithFallback.tsx   # Imagen con manejo de errores de carga
```

Este módulo contiene utilidades originadas en la integración con **Figma Make** (herramienta que genera código React desde diseños Figma).

---

## 🖼️ `ImageWithFallback.tsx`

**Componente wrapper de `<img>`** que muestra un placeholder SVG cuando la imagen original falla en cargar.

### Props

```typescript
// Extiende todas las props nativas de <img>
React.ImgHTMLAttributes<HTMLImageElement>
```

No tiene props personalizadas; acepta cualquier prop estándar de imagen HTML (`src`, `alt`, `className`, `style`, etc.).

### Comportamiento

```
Estado inicial → Renderiza <img> normal
         ↓ (onError)
Estado error → Renderiza <div> con imagen SVG de fallback
```

### Imagen de fallback

Es un SVG codificado en Base64 que muestra:
- Un rectángulo con esquinas redondeadas
- Una montaña/paisaje estilizado
- Un círculo (sol/luna)
- Opacidad 0.3, color negro

```
data:image/svg+xml;base64,PHN2Zy...
```

### Detalle del estado de error

Cuando el `<img>` original dispara `onError`:
1. Se activa el estado `didError = true`.
2. Se reemplaza el `<img>` por un `<div>` con fondo gris claro (`bg-gray-100`).
3. Dentro del div se muestra la imagen SVG de fallback.
4. Se preserva el atributo `data-original-url={src}` para depuración.

### Uso

```tsx
import { ImageWithFallback } from "../figma/ImageWithFallback";

<ImageWithFallback
  src={report.url_imagen}
  alt={report.titulo}
  className="w-full h-48 object-cover rounded-lg"
/>
```

### Integración con Vite

El archivo `vite.config.ts` incluye un plugin `figmaAssetResolver()` que resuelve imports con prefijo `figma:asset/` al directorio `src/assets/`. Esto permite que los assets exportados de Figma se resuelvan correctamente en el bundler.

```typescript
// vite.config.ts
function figmaAssetResolver() {
  return {
    name: 'figma-asset-resolver',
    resolveId(id) {
      if (id.startsWith('figma:asset/')) {
        const filename = id.replace('figma:asset/', '');
        return path.resolve(__dirname, 'src/assets', filename);
      }
    },
  };
}
```
