# 04 · Sistema de diseño y componentes base (`components/ui/`)

## Identidad visual

La interfaz toma sus colores del logo: el **pin y la ola azules**, la **colina verde** y el **sol amarillo**.

| Archivo | Uso |
|---|---|
| `public/favicon.svg` | Isotipo a color (pin + colina + sol + ola). Favicon y logo compacto. |
| `src/assets/logo-completo.svg` | Logo completo (isotipo + "Buenaventura Reporta") para fondos claros. |
| `src/assets/logo-completo-blanco.svg` | Versión para fondos oscuros (texto blanco, ola más clara). |
| `src/assets/logo-marca-blanco.svg` | Isotipo para fondos oscuros. |
| `src/assets/nombre-logo.svg` | Solo el nombre. |

En el código, el logo siempre se usa con el componente [`BrandLogo`](05-COMPONENTES-COMUNES.md#brandlogo).

### Colores (`src/styles/theme.css`)

Definidos en un bloque `@theme` de Tailwind 4, así que generan clases normales (`bg-brand-600`, `text-leaf-500`, `ring-sun-400`…).

| Escala | Color ancla del logo | Uso |
|---|---|---|
| `brand-50` … `brand-950` | `brand-500` `#137cc8` (ola), `brand-600` `#0a5caa` (pin), `brand-900` `#072e57` (texto del logo) | Color principal: botones, enlaces, selección, encabezados. |
| `leaf-50` … `leaf-900` | `leaf-500` `#398656` (colina) | Acentos positivos, "resuelto", éxito. |
| `sun-50` … `sun-900` | `sun-400` `#f8b71d` (sol) | Llamados a la acción secundarios, "pendiente", avisos. |

Reglas:

- **Botón principal**: `brand-600`. **Llamado a la acción sobre fondo oscuro**: `sun-400` con texto `brand-900`.
- **Textos de títulos**: `brand-900`. Texto de apoyo: `gray-600` o más oscuro (contraste mínimo 4.5:1).
- Los `green`, `yellow`, `red` de Tailwind se reservan para **estados** (resuelto, pendiente, error), categorías de incidencia y colores propios de cada entidad.

### Degradados

| Clase | Uso |
|---|---|
| `bg-brand-gradient` | Azul pin → azul ola. Elementos de marca pequeños. |
| `bg-brand-gradient-deep` | Navy → azul. Animaciones de bienvenida y cierre de sesión. |
| `bg-brand-soft` | Fondo muy claro azul → blanco → amarillo suave. |

### Tipografía y forma

- Fuente **Nunito** (redondeada, como el texto del logo) para toda la interfaz, cargada en `index.html`.
- Radio base `--radius: 0.75rem`; tarjetas `rounded-2xl`, botones e inputs `rounded-xl`.
- Variables tipo shadcn en `:root` (`--primary`, `--ring`, `--background`…) alineadas con la marca (`--primary: #0a5caa`).

### Estilos globales (`src/styles/index.css`)

- `scroll-behavior: smooth` para los enlaces a secciones (`#como-funciona`).
- **Movimiento reducido**: con `prefers-reduced-motion: reduce` todas las animaciones y transiciones se vuelven instantáneas.
- `.map-preview`: oculta los controles de zoom en la vista previa no interactiva del mapa.
- Estilos de los *popups* de Leaflet (`.report-popup`).
- Animación `animate-marquee` (definida en `theme.css`) para el carrusel de reseñas.

---

## Componentes base

```
src/components/ui/
├── Button.tsx
├── button-variants.ts   # Clases de botón reutilizables en enlaces
├── Input.tsx
├── Textarea.tsx
├── Card.tsx
└── Badge.tsx
```

### `Button`

```tsx
<Button variant="primary" size="md">Guardar cambios</Button>
```

| Prop | Valores | Por defecto |
|---|---|---|
| `variant` | `primary` (azul), `secondary` (amarillo sol), `outline`, `ghost`, `danger`, `warning`, `entity` (color de la entidad) | `primary` |
| `size` | `sm`, `md`, `lg` | `md` |

Acepta todas las props de `<button>`. Incluye foco visible, estado deshabilitado y una leve reducción al presionar.

### `buttonVariants()` (`button-variants.ts`)

Devuelve las mismas clases del botón para aplicarlas a un **enlace**. Úsalo en lugar de meter un `<Button>` dentro de un `<Link>` (elementos interactivos anidados son un error de accesibilidad):

```tsx
import { buttonVariants } from "../../components/ui/button-variants";

<Link to="/register" className={buttonVariants({ variant: "secondary", size: "lg" })}>
  Crear cuenta
</Link>
```

Vive en un archivo aparte para que `Button.tsx` solo exporte componentes (regla de Fast Refresh).

### `Input`

```tsx
<Input
  label="Correo electrónico"
  type="email"
  autoComplete="email"
  placeholder="nombre@correo.com"
  hint="Te enviaremos un enlace para verificarlo."
  error={errores.email}
/>
```

| Prop | Descripción |
|---|---|
| `label` | Etiqueta visible, **asociada al campo** (`htmlFor` + `id` automático con `useId`). |
| `hint` | Texto de ayuda bajo el campo. Se oculta cuando hay error. |
| `error` | Mensaje de error: borde rojo, `aria-invalid` y `aria-describedby`. |
| `icon` | Ícono a la izquierda. |

Con `type="password"` agrega solo un botón **mostrar / ocultar contraseña** (con `aria-label` y `aria-pressed`). Altura mínima de 48 px para tocar cómodo en el celular.

### `Textarea`

Igual que `Input` (`label`, `error`, `id` automático), sin redimensionar.

### `Card`

Contenedor blanco con borde sutil y sombra ligera. Con `hover` agrega elevación al pasar el mouse y cursor de enlace.

### `Badge`

```tsx
<Badge variant="success">Resuelto</Badge>
```

| Variante | Estilo |
|---|---|
| `default` | Azul de marca claro |
| `secondary` | Gris |
| `success` | Verde hoja |
| `warning` | Amarillo sol |
| `danger` / `error` / `destructive` | Rojo |
| `info` | Azul |
| `outline` | Solo borde |
| `entity` | Colores de la entidad (variables `--entity-*`) |

Para estados de reporte no elijas la variante a mano: usa `getReportStatus()` ([03-CAPA-API.md](03-CAPA-API.md#report-statusts)).
