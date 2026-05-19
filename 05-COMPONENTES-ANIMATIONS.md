# 05 — Componentes de Animación (`components/animations/`)

## 📁 Estructura

```
src/app/components/animations/
├── WelcomeAnimation.tsx   # Animación de bienvenida post-login
└── LogoutAnimation.tsx    # Animación de despedida pre-logout
```

Ambos usan **Motion** (Framer Motion v12) para animaciones declarativas.

---

## 👋 `WelcomeAnimation.tsx`

**Animación fullscreen** que se muestra después de un login exitoso.

### Props

```typescript
interface WelcomeAnimationProps {
  userName: string;     // Nombre del usuario para personalizar saludo
  onComplete: () => void; // Callback cuando la animación termina
}
```

### Secuencia de animación

| Orden | Elemento | Animación | Delay |
|---|---|---|---|
| 1 | Fondo | Fade in con gradiente `yellow → green → yellow` | 0s |
| 2 | Emoji 👋 | Scale 0→1.2→1 + rotación 360° | 0.2s |
| 3 | Icono MapPin | Scale 0→1 en círculo blanco | 0.3s |
| 4 | "¡Bienvenido, {nombre}!" | Slide up + fade in | 0.5s |
| 5 | "Tu ciudad te necesita" | Fade in con iconos Sparkles | 0.7s |
| 6 | 20 partículas blancas | Dispersión radial aleatoria | 0.9s+ |

### Uso

```tsx
import { WelcomeAnimation } from "../components/animations/WelcomeAnimation";

// En LoginPage.tsx:
{showWelcome && (
  <WelcomeAnimation
    userName={profile.nombre_completo}
    onComplete={() => navigate("/user")}
  />
)}
```

---

## 🚪 `LogoutAnimation.tsx`

**Animación fullscreen** que se muestra al cerrar sesión.

### Props

```typescript
interface LogoutAnimationProps {
  onComplete: () => void; // Callback cuando termina → redirige a login
}
```

### Secuencia de animación

| Orden | Elemento | Animación | Duración |
|---|---|---|---|
| 1 | Fondo | Gradiente más oscuro `yellow-600 → green-700` | — |
| 2 | Emoji 👋 | Scale 1→1.3→0 con rotación sutil | 1.2s |
| 3 | Icono LogOut | Bounce vertical + rotación | 0.8s |
| 4 | "¡Hasta pronto!" | Fade out | 0.6s (delay 0.6s) |
| 5 | 3 ondas circulares | Scale 0→3 con opacity 0.5→0 | 1s (escalonado) |

### Uso

```tsx
import { LogoutAnimation } from "../components/animations/LogoutAnimation";

// En UserDashboard.tsx:
{showLogout && (
  <LogoutAnimation
    onComplete={() => navigate("/login")}
  />
)}
```

---

## 🎨 Paleta de colores de animaciones

Ambas animaciones utilizan la paleta institucional del proyecto:
- **Primary gradient**: `from-yellow-500 via-green-600 to-yellow-600`
- **Logout gradient**: `from-yellow-600 via-green-700 to-yellow-700` (más oscuro)
- **Elementos**: Blanco sobre el gradiente
- **Icono de bienvenida**: `text-green-600` (MapPin)
- **Icono de logout**: `text-yellow-600` (LogOut)
