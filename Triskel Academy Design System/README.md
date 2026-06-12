# Triskel Academy — Design System

> A small, friendly design system for **Triskel Academy**, a Pilates studio app that runs the studio (teacher) and serves the students from a single PWA. Reformer, Mat, and Funcional are first-class concepts. Everything is in Argentine Spanish.

The system was reconstructed from a working web app, not from a Figma file — so the tokens, components, and copy in here are reverse-engineered to be faithful to the product as it ships today, with light cleanup proposed where the two panels had drifted apart.

---

## Sources

- **GitHub:** [`elterco2012-dev/triskel-academy`](https://github.com/elterco2012-dev/triskel-academy)
- Key files referenced:
  - [`/panel/index.html`](https://github.com/elterco2012-dev/triskel-academy/blob/main/panel/index.html) — teacher panel (≈3,200 lines, single file)
  - [`/panel/alumna.html`](https://github.com/elterco2012-dev/triskel-academy/blob/main/panel/alumna.html) — student panel (≈730 lines, mobile-first)
  - [`/manifest.json`](https://github.com/elterco2012-dev/triskel-academy/blob/main/manifest.json) — PWA brand color & icon
- **Backend:** Supabase (`triskel_*` RPCs); not represented here — this system is visual.

> Browse the repo if you want to dig deeper than this skill: variable names, exact RPC shapes, and the full inventory of modals all live in those two HTML files.

---

## What Triskel does

Triskel Academy is a one-instructor Pilates studio (the teacher is **Amira**). The PWA replaces a folder full of spreadsheets and WhatsApps with a single place to:

| Surface             | Who it's for      | Lives at         | The job it does                                                                |
| ------------------- | ----------------- | ---------------- | ------------------------------------------------------------------------------ |
| **Teacher Panel**   | Studio owner      | `/panel/`        | Manage students, schedule, plan classes (exercise bank), collect payments, send WhatsApp reminders. |
| **Student Panel**   | Enrolled students | `/panel/alumna`  | See my schedule, the modality I'm enrolled in, my payment status, and report a payment to Amira. |

Both panels share one Supabase backend, one logo, and one purple brand color. They have **deliberately different layouts** — desktop-first sidebar app vs. mobile-first phone app — but were drifting in shadows, radii, spacing, and casing. This system is the convergence point.

---

## File index

| Path                       | What it is                                                      |
| -------------------------- | --------------------------------------------------------------- |
| `README.md`                | This document.                                                  |
| `SKILL.md`                 | Agent-Skill-compatible entry point.                             |
| `colors_and_type.css`      | All CSS custom properties: colors, type, spacing, motion.       |
| `assets/`                  | Brand assets (logos).                                           |
| `preview/`                 | Design-system review cards (rendered in the Design System tab). |
| `ui_kits/teacher-panel/`   | Teacher Panel UI kit (sidebar app — desktop-first).             |
| `ui_kits/student-panel/`   | Student Panel UI kit (bottom-nav app — mobile-only).            |

---

## CONTENT FUNDAMENTALS

**Language.** Argentine Spanish. Voseo is used naturally ("avisaste", "pagás", "regularizá", "podés"). No formal "usted" anywhere.

**Voice.** Warm, low-friction, first-person from the student's perspective ("Mi cuenta", "Mi inscripción", "Mi panel de alumna"). The teacher panel speaks **at** the studio owner ("Pendientes", "Recordatorios — 3 alumnas", "+ Nueva alumna").

**Pronouns.** Student panel = first-person possessive (mi/mis). Teacher panel = third-person about students ("Alumna", "alumnas activas"). Both panels personify the teacher by her first name **Amira** — never "the instructor", never "el profesor":
- "Amira está revisando"
- "Pedile a Amira que la active"
- "Hablá con Amira para inscribirte"

**Casing.** Sentence-case for buttons and titles ("Ingresar", "Nueva alumna", "Avisar pago", "Inicio"). Section headers in the teacher panel use **`UPPERCASE` micro-labels** (`text-transform: uppercase; font-size: 11px; letter-spacing: .06em`) — that's the `--type-label` token. The big page titles use the serif display font in plain Title case ("Inicio", "Alumnas").

**Emoji.** Heavy in production. Used as:
1. **Iconography** in nav (🏠 🌿 📅 📝 📚 💰), buttons (📲 ▶ ⏸), and badges.
2. **Status semantics** (🔴 vence hoy, 🟠 atrasada, 🟡 próxima, ✅ pagada, ⏳ pendiente, ⚠️ sin pago).
3. **Voice** in WhatsApp templates — every default message includes 🌿 as a Triskel sign-off.

> ⚠️ The emoji-as-icon pattern reads as informal/MVP. The system documents it as the current state and recommends **Lucide icons** as the upgrade path (see ICONOGRAPHY).

**Money.** Argentine peso formatting: `$12.500` (period-separated thousands, `toLocaleString('es-AR')`). Always shown with the `$` prefix, no decimals.

**Dates.** `es-AR` long format ("noviembre 2025"), short format ("12 nov – 16 nov"), or numeric `YYYY-MM` keys for storage. Days of the week abbreviated three-letter lowercase: `lun mar mie jue vie` — the studio is closed on weekends.

**Modality labels.** Always one of three, always lowercase in code, **Title-case in UI**: `mat` → "Mat", `reformer` → "Reformer", `funcional` → "Funcional". Never translated, never abbreviated.

**WhatsApp message templates** (taste samples — these ship in the app):
> Hola {nombre}! 🌿 Te recordamos que hoy vence tu cuota mensual de Triskel Academy{monto}. Ante cualquier consulta escribinos. ¡Gracias!

> Hola {nombre}! 🌿 Tenés una cuota pendiente de Triskel Academy{monto}. Cuando puedas, regularizá tu pago. ¡Gracias!

Notice: 🌿 sign-off, no "Hola sra.", direct voseo, exclamation marks soft but present, "¡Gracias!" never "Gracias.".

**Empty / error states.** Always two lines: the situation, then what to do.
> "No tenés inscripciones activas.\nHablá con Amira para inscribirte."

> "Tu cuenta no está vinculada aún.\nPedile a Amira que la active."

---

## VISUAL FOUNDATIONS

### Colors

**One brand violet, three modality colors, three semantic colors.** That's the entire palette. See `colors_and_type.css` for the canonical tokens.

| Family       | Token                       | Hex        | Use                                       |
| ------------ | --------------------------- | ---------- | ----------------------------------------- |
| Brand        | `--brand-violet`            | `#7C5CBF`  | Primary buttons, active nav, links.       |
| Brand        | `--brand-violet-deep`       | `#5B3F9E`  | Hover/pressed.                            |
| Brand        | `--brand-violet-tint`       | `#EDE9F8`  | Selected nav background, soft surfaces.   |
| Modality     | `--mod-mat`                 | `#1D9E75`  | "Mat" badges, slot borders.               |
| Modality     | `--mod-reformer`            | `#2563EB`  | "Reformer" badges, slot borders.          |
| Modality     | `--mod-funcional`           | `#D97706`  | "Funcional" badges, slot borders.         |
| Status       | `--status-danger` `#A32D2D` | warning `#D97706` | success `#1D9E75` (same as Mat). |

> The **logo** is tri-color (magenta swirl + yellow swirl + cyan swirl) — those colors do **not** appear in UI. They're reserved for the mark and exposed as `--brand-magenta/-yellow/-cyan` only for hero artwork.

### Type

- **Display** — `DM Serif Display` (Google Fonts). Used for page titles, modal titles, and the wordmark. Italic exists but is rarely used.
- **Sans (UI)** — `DM Sans` (400, 500, 600, 700). Everything else.
- **No mono** is used in production; the token exists for future code-display needs.

Hierarchy in production:
- Page title (`.ptitle`) — serif, 1.6rem
- Section micro-label (`.ctitle`) — sans 11px uppercase, letter-spacing .06em, muted
- Body — sans 13px (teacher) / 15px (student)
- Metric numeric — sans 700, 1.5rem

> The student panel currently falls back to system fonts (`-apple-system,BlinkMacSystemFont,'Segoe UI',sans-serif`) instead of loading DM Sans like the teacher panel does. **Unification:** load DM Sans on both. This system assumes that fix.

### Spacing

A coarse 4 / 8 / 12 / 16 / 24 scale, no half-steps. Page padding is `2rem` (32px) on desktop, `1rem` (16px) on mobile. Card padding is `1.25rem` (20px) on the teacher side, `1rem` (16px) on the student side.

### Radii

- `--radius-sm`: 6px — chips, small badges (`.badge-mod` uses 99px pill).
- `--radius`: 9px — inputs, buttons (this is the dominant control radius).
- `--radius-lg`: 14px — cards, modals.
- Bottom-sheet modals on mobile: `20px 20px 0 0`.

### Shadows

- **Teacher panel** uses no shadows by default — depth is communicated through borders (`rgba(0,0,0,0.07)`).
- **Student panel** uses one branded shadow: `0 2px 12px rgba(108,91,123,0.10)` (violet-tinted). The system promotes this to `--shadow` and uses it everywhere we want depth.
- Modals get `--shadow-lg`, dropdowns get `--shadow-sm`.

### Backgrounds

- **Page background** is a warm off-white `#F8F8F6` on both panels — never pure `#FFFFFF`. Cards are white on top of that.
- **Hero / auth screen** on the student panel uses one gradient: `linear-gradient(145deg, #f4f0f8, #e8dff0)` — a soft violet wash. This is the **only gradient** in production.
- **Notification banner** on the student panel uses a violet gradient: `linear-gradient(135deg, #6c5b7b, #a689c0)`. Used sparingly.
- No background imagery, no patterns, no textures. No grain. No hand-drawn illustrations.

### Hover & press

- **Hover** (desktop only): swap to `--bg-muted` background, no color shift on the text. Buttons darken to `--brand-violet-deep`.
- **Press** (mobile): `opacity: 0.85` on primary buttons. `background: #f0ebf5` on icon-buttons. The student panel uses `:active` rather than `:hover` since it's touch-only.
- **Focus** — input borders shift to `--brand-violet`, no outline.

### Borders

`1px solid rgba(0,0,0,0.07)` on cards. `1.5px solid #ddd` on student-panel inputs (slightly heavier for touch). Inputs on focus → `--brand-violet`, 1.5px.

### Transitions

`120ms` for color/background, `200ms` for transforms. Easing is `var(--ease-out)` (`cubic-bezier(0.16, 1, 0.3, 1)`). No bounces. No spring. The schedule slots have a subtle `translateY(-1px)` lift on hover — that's the only motion flourish in the app.

### Layout rules

- **Teacher panel.** Fixed 180px left sidebar, content `margin-left: 180px; padding: 2rem`. Below 680px the sidebar disappears and a 4-item bottom nav appears. Modals are centered desktop, bottom-sheet on mobile.
- **Student panel.** Always single-column, `max-width: 480px`, centered on desktop with bg color around it. Sticky top header. Fixed bottom nav with 4 items. Content area scrolls.
- **Modal pattern.** Desktop: centered, `max-width: 540px`. Mobile: bottom-sheet, full-width, rounded top corners only, drag-handle bar at top.

### Cards

Two card flavors, both in `colors_and_type.css`:
- **Flat card** (teacher) — white bg, 1px border, 14px radius, no shadow.
- **Floating card** (student) — white bg, no border, 14px radius, violet-tinted shadow.

Cards may carry a left accent border in `--mod-*` or `--status-*` color to indicate state (`border-left: 4px solid var(--mod-mat)`). This is the only "ornament" allowed on cards.

### Transparency / blur

Used only in modal overlays: `rgba(0,0,0,0.4)` scrim, no `backdrop-filter`. The app does not blur anything.

### Iconography (one-liner)

Currently emoji-only. See the **ICONOGRAPHY** section.

---

## ICONOGRAPHY

**Current state (production):** the entire icon system is **Unicode emoji**. Every nav item, every button accent, every status badge, every "remind via WA" link uses an emoji glyph. There is no icon font, no SVG sprite, no `<svg>` icons anywhere in the codebase.

| Where             | Glyphs in use                                                          |
| ----------------- | ---------------------------------------------------------------------- |
| Teacher sidebar   | 🏠 Inicio · 👤 Alumnas · 📅 Horarios · 📝 Planificar · 📚 Historial · 💰 Pagos · ⚙ Tarifas · 💬 Mensajes WA |
| Teacher bottom nav (mobile) | 🏠 · 📝 · 👤 · 💰                                            |
| Student bottom nav | 🏠 Inicio · 📅 Horarios · 💳 Pagos · 👤 Perfil                          |
| Status            | 🔴 vence hoy · 🟠 atrasada · 🟡 próxima · ✅ pagada · ⏳ pendiente · ⚠️ sin pago |
| Actions           | ✓ Pagó · ▶ Iniciar · ⏸ Pausar · ↩ Salir · 🚪 Cerrar sesión · 📲 Recordar · 📋 Clonar · 💬 WhatsApp · 🌿 (brand sign-off) |
| Brand voice       | 🌿 (consistent sign-off in WhatsApp templates — green sprig = wellness) |

**Logos.** `assets/logo-triskel.png` (1025×1018) — the tri-color triskel mark on transparent-fallback white. `assets/logo.jpeg` (1521×1521) — the same mark used as the PWA icon and as the round avatar on the login screen.

> ⚠️ **Substitution to flag.** The production app has no SVG icon set. The Pilates context is gendered, intimate, low-tech — emoji feels right *for now*, but the system recommends migrating to **Lucide** for an instantly more "professional app" feel:
>
> | Emoji used | Lucide equivalent  |
> | ---------- | ------------------ |
> | 🏠         | `home`             |
> | 👤         | `user` / `users`   |
> | 📅         | `calendar`         |
> | 📝         | `clipboard-list`   |
> | 📚         | `book-open`        |
> | 💰         | `wallet` / `dollar-sign` |
> | 💳         | `credit-card`      |
> | 💬         | `message-circle`   |
> | 🔔         | `bell`             |
> | ⚠️         | `alert-triangle`   |
> | ✅         | `check-circle-2`   |
> | ⏳         | `clock`            |
> | ▶ ⏸       | `play` / `pause`   |
> | 🌿         | `leaf`             |
> | 🌙         | `moon`             |
>
> Both options are surfaced in the UI kit as a toggle. Pick one and unify.

**Brand mark usage.**
- The triskel mark always appears inside a circle (`border-radius: 50%; object-fit: cover`) — never on its own with a transparent corner.
- On the auth/login screen it's 72px–80px, white background, 2px violet border.
- In the sidebar header it's 28px × 28px, no border.
- The wordmark "Triskel Academy" is set in `DM Serif Display`, 1.5rem, no italic, never tracked.

---

## What was missing / substituted

| Thing                          | Action                                                                     |
| ------------------------------ | -------------------------------------------------------------------------- |
| Real icon set                  | **Substituted Lucide** (CDN) as an upgrade path; emoji documented as-is.   |
| Standalone Figma file          | Not provided. Tokens reverse-engineered from CSS in HTML.                  |
| Brand-tone guidelines doc      | Not provided. Inferred from WhatsApp templates + UI copy.                  |
| Photography / illustration     | None in product. System has no photo style — recommend not introducing.    |
| Marketing site                 | The repo has none. Only the panel is represented in UI kits.               |

---

## What I'd improve to make it feel more professional

The user's brief was *"qué mejorarías de esta app… para hacerla un app más profesional"*. This system already incorporates the recommended fixes; here's the short version:

**1. Unify the two panels' visual language.**
The teacher panel uses flat 1px-border cards on `#f8f8f6`; the student panel uses shadowed, no-border cards on `#f4f0f8`. They feel like two products. This system promotes the **shadow card** (violet-tinted) to default for both, with the flat card available as a dense alternative. Same `--radius-lg: 14px`, same `--brand-violet`, same fonts.

**2. Swap emoji for a real icon set.**
Emoji in nav/buttons reads as "weekend project". Lucide is one CDN line and instantly raises the perceived polish. The README ICONOGRAPHY section has the full mapping. Keep 🌿 in WhatsApp templates — that emoji *is* the brand sign-off.

**3. Load DM Sans on the student panel.**
The student panel falls back to system fonts; the teacher panel loads DM Sans. Side-by-side they look like different apps. Three-line fix.

**4. Stop using gradients as accents.**
Two gradients exist: the auth-screen wash (`#f4f0f8 → #e8dff0`) and the notif banner (`#6c5b7b → #a689c0`). The wash is fine — soft, calm. The notif banner gradient is the only "fake-3D" element in the app and reads as a tooltip from 2016. **Replace with a flat violet `#7C5CBF` card with white text** and the same content.

**5. Standardize the "alerted state" pattern.**
There are three different ways to convey *attention needed*: red left-border, red badge pill, red text. Pick one: **4px left-accent border + neutral copy** wins. The system documents this as `card-accent-danger`.

**6. Type rhythm.**
The teacher panel has `1.6rem` page titles and `13px` body. That's a tiny gap. The system adds `--type-display` (2.4rem serif) for any future hero/empty-state moment, so the brand has somewhere to breathe.

**7. Empty states.**
The app has good empty-state copy ("Hablá con Amira") but no illustration or visual relief — it's a single line of muted text. Add a 32–48px symbolic glyph or simple icon above the copy. The student panel already does this on the Horarios empty state (📅 calendar emoji) — propagate the pattern.

**8. The "Avisar pago" flow is the strongest interaction in the product. Promote it.**
On the student home, when status is "sin pago", the only button on the screen should be that one. The system shows it that way already, but the danger card competes with the notification banner — drop the notif banner when there's an unpaid cuota in the current month.

**9. WhatsApp ergonomics.**
The teacher panel's "📲 Recordar a todas" button is buried in a card. Surface it as a sticky bottom action when ≥3 alumnas have pending cuotas — it's the single most valuable workflow Amira has.

**10. Dark mode.**
The teacher panel has a dark-mode toggle in the sidebar; the student panel does not. Either ship both or remove both. The tokens in `colors_and_type.css` already define `[data-theme="dark"]` for both.

---

## Asking for more

If you're iterating on this system, the highest-value next inputs are:

1. **The studio's color preferences** — is violet `#7C5CBF` locked, or open to a calmer wellness-y green/sage?
2. **Lucide vs. emoji decision** — should the kit ship icon-only?
3. **A photography direction** — every Pilates studio website has imagery. This product has none.
4. **Real DM Sans/DM Serif Display webfont files** if self-hosting is needed (currently Google-Fonts CDN).
