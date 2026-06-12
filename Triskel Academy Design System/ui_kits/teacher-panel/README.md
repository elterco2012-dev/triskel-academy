# Teacher Panel UI Kit

Interactive recreation of `/panel/index.html` — the desktop-first web app Amira (the studio owner) uses to run Triskel Academy.

## Files

| File                 | What it is                                                                |
| -------------------- | ------------------------------------------------------------------------- |
| `index.html`         | Boot file. Wraps the app inside a browser-window frame at 1280×760.       |
| `teacher-panel.css`  | All component styles, scoped under `.tp-*` selectors.                     |
| `data.js`            | Fixture data (matches the `DB.*` shapes used by the production HTML).     |
| `TeacherPrimitives.jsx` | Sidebar, badges, metric cards, alumna row, card primitives.            |
| `TeacherScreens.jsx`    | Login + 5 page views + Nueva-alumna modal.                            |

## Screens

1. **Login** — minimalist card, logo top, single column.
2. **Inicio (Dashboard)** — recordatorios card, 4 metric cards, modality distribution, latest classes, weekly summary card.
3. **Alumnas** — grouped list of students with inline status pills and edit / pause controls.
4. **Horarios** — 5-column weekly schedule grid, each slot color-coded by modality with capacity indicators.
5. **Pagos** — current-month payment roster with one-click "marcar pagado" for outstanding cuotas.

Two modals are wired:
- **Nueva alumna** — full form with contraindications callout in red.
- **Toast notifications** for actions not modeled in the kit (Tarifas, Mensajes WA, Modo oscuro).

The `clases` (planificar) and `historial` tabs route to the Inicio view as placeholders — that surface was too large for a faithful recreation in the time budget and is documented as a follow-up.

## Layout

- Fixed 180px sidebar, content area scrolls.
- Designed at desktop widths (≥1024px); the production app collapses to a 4-item bottom nav under 680px (not modeled here — the kit is desktop-only).
- All modals are centered overlays inside the browser-window frame.

## Known gaps vs. production

- No real Supabase data; everything mutates the in-memory fixture.
- The class planner (banco de ejercicios + ejercicios builder) and historial views are stubs.
- Mobile responsive behaviour (bottom nav, sheet modals) is not replicated — see the student-panel kit for the mobile pattern.
- Tarifas, Mensajes WA, dark-mode toggle, recordatorio masivo, and search dropdown are all toast stubs.
