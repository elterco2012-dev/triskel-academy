# Student Panel UI Kit

Interactive recreation of `/panel/alumna.html` — the mobile PWA that students log into to see their schedule and report payments.

## Files

| File                | What it is                                                              |
| ------------------- | ----------------------------------------------------------------------- |
| `index.html`        | Boot file. Wraps the app in an iOS device frame.                        |
| `student-panel.css` | All component styles, scoped under `.sp-*` selectors.                  |
| `data.js`           | Fixture data (the shape `triskel_get_mi_ficha` returns from Supabase). |
| `StudentPrimitives.jsx` | Small reusable components: card, chip, schedule row, header, nav, toast. |
| `StudentScreens.jsx`    | Auth + 4 main tabs + Aviso pago modal.                                |

## Screens

1. **Login** — purple-gradient hero, centered card, email + password.
2. **Inicio** — current-month pago status + today's class + my enrollments.
3. **Horarios** — enrollments grouped by day of the week.
4. **Pagos** — current-month status (cobrado / aviso / sin) + history.
5. **Perfil** — photo, profile rows, modality chips, logout.

Interact: log in, navigate tabs, tap **"Avisar que pagué"** to open the bottom-sheet modal and submit a payment notification. After submission, the home + Pagos screens reflect the pending state.

## Layout constraints

- `max-width: 480px`, centered. The kit ships in a 402×844 iOS frame so it reads as a real phone.
- Sticky top header, fixed bottom nav, content scrolls between them.
- Modal opens as a bottom-sheet (slides up from the bottom of the device frame).

## Known gaps vs. production

- No push notifications (the production app uses VAPID).
- No actual Supabase calls — fixture only.
- The profile photo upload is a no-op toast.
