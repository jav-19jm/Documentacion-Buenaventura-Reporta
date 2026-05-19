# 04 — Componentes UI (`components/ui/`)

## 📁 Estructura

```
src/app/components/ui/
├── Badge.tsx          # Etiqueta de estado (custom)
├── Button.tsx         # Botón con variantes (custom)
├── Card.tsx           # Contenedor tarjeta (custom)
├── Input.tsx          # Campo de texto (custom)
├── Textarea.tsx       # Área de texto (custom)
├── utils.ts           # Función cn() para clases Tailwind
├── use-mobile.ts      # Hook de detección mobile
│
│ --- Componentes shadcn/ui (Radix UI) ---
├── accordion.tsx
├── alert.tsx
├── alert-dialog.tsx
├── aspect-ratio.tsx
├── avatar.tsx
├── breadcrumb.tsx
├── calendar.tsx
├── carousel.tsx
├── chart.tsx
├── checkbox.tsx
├── collapsible.tsx
├── command.tsx
├── context-menu.tsx
├── dialog.tsx
├── drawer.tsx
├── dropdown-menu.tsx
├── form.tsx
├── hover-card.tsx
├── input-otp.tsx
├── label.tsx
├── menubar.tsx
├── navigation-menu.tsx
├── pagination.tsx
├── popover.tsx
├── progress.tsx
├── radio-group.tsx
├── resizable.tsx
├── scroll-area.tsx
├── select.tsx
├── separator.tsx
├── sheet.tsx
├── sidebar.tsx
├── skeleton.tsx
├── slider.tsx
├── sonner.tsx
├── switch.tsx
├── table.tsx
├── tabs.tsx
├── toggle.tsx
├── toggle-group.tsx
└── tooltip.tsx
```

---

## 🔧 Utilidad `cn()` — `utils.ts`

```typescript
import { type ClassValue, clsx } from "clsx";
import { twMerge } from "tailwind-merge";

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs));
}
```

Combina `clsx` (condicionales de clase) con `tailwind-merge` (resuelve conflictos de Tailwind). Es la base de todo el Design System.

---

## 🏷️ `Badge.tsx`

**Etiqueta de estado** con 7 variantes.

```typescript
interface BadgeProps extends HTMLAttributes<HTMLSpanElement> {
  variant?: "default" | "success" | "warning" | "danger" | "info" | "outline" | "entity";
}
```

| Variante | Colores | Uso típico |
|---|---|---|
| `default` | gris | Estado genérico |
| `success` | verde | Estado activo, resuelto |
| `warning` | amarillo | Pendiente, suspendido |
| `danger` | rojo | Bloqueado, cancelado, rol admin |
| `info` | azul | En proceso, rol entidad |
| `outline` | borde gris | Categorías |
| `entity` | CSS variables `--entity-*` | Branding dinámico de entidad |

**Uso:**
```tsx
<Badge variant="success">Activo</Badge>
<Badge variant="warning">Pendiente</Badge>
```

---

## 🔘 `Button.tsx`

**Botón** con 6 variantes y 3 tamaños.

```typescript
interface ButtonProps extends ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: "primary" | "secondary" | "outline" | "ghost" | "danger" | "entity";
  size?: "sm" | "md" | "lg";
}
```

| Variante | Colores | Uso típico |
|---|---|---|
| `primary` | azul | Acciones principales |
| `secondary` | verde | Acciones secundarias/confirmación |
| `outline` | borde azul | Acciones alternativas |
| `ghost` | transparente/gris | Acciones terciarias |
| `danger` | rojo | Eliminar, bloquear |
| `entity` | CSS variables | Dashboard de entidad |

| Tamaño | Padding |
|---|---|
| `sm` | `px-3 py-1.5 text-sm` |
| `md` | `px-4 py-2 text-base` |
| `lg` | `px-6 py-3 text-lg` |

---

## 📦 `Card.tsx`

**Contenedor** con sombra y esquinas redondeadas.

```typescript
interface CardProps extends HTMLAttributes<HTMLDivElement> {
  hover?: boolean; // Añade efecto de elevación al hover
}
```

Base: `bg-white rounded-lg shadow-md p-4`.

---

## ✏️ `Input.tsx`

**Campo de texto** con soporte para label y validación.

```typescript
interface InputProps extends InputHTMLAttributes<HTMLInputElement> {
  label?: string;  // Etiqueta opcional sobre el input
  error?: string;  // Mensaje de error debajo del input
}
```

Si `error` está presente: borde rojo + texto de error.

---

## 📝 `Textarea.tsx`

**Área de texto** con la misma API que `Input`.

```typescript
interface TextareaProps extends TextareaHTMLAttributes<HTMLTextAreaElement> {
  label?: string;
  error?: string;
}
```

Incluye `resize-none` por defecto.

---

## 📱 `use-mobile.ts`

Hook que detecta si el viewport es mobile (< 768px) usando `matchMedia`.

```typescript
export function useIsMobile(): boolean
```

---

## 📚 Componentes shadcn/ui

Los **43 componentes restantes** son generados por shadcn/ui y wrappean primitivos de Radix UI. Todos siguen el patrón:

1. Importan de `@radix-ui/react-*`
2. Usan `cn()` para combinar clases
3. Usan `forwardRef` para forwarding de refs
4. Exponen `className` como prop para override

> **No se modifican directamente.** Se personalizan vía `theme.css` (CSS variables) o pasando `className`.
