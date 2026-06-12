---
name: triskel-academy-design
description: Use this skill to generate well-branded interfaces and assets for Triskel Academy (a Pilates studio PWA serving Reformer, Mat, and Funcional classes), either for production or for throwaway prototypes/mocks/etc. Contains essential design guidelines, colors, type, fonts, assets, and UI kit components for prototyping. Triskel ships two surfaces: a desktop-first teacher panel (sidebar) and a mobile-first student panel (bottom-nav). All UI copy is Argentine Spanish (voseo).
user-invocable: true
---

Read the `README.md` file within this skill, and explore the other available files.

If creating visual artifacts (slides, mocks, throwaway prototypes, etc), copy assets out and create static HTML files for the user to view. If working on production code, you can copy assets and read the rules here to become an expert in designing with this brand.

If the user invokes this skill without any other guidance, ask them what they want to build or design, ask some questions, and act as an expert designer who outputs HTML artifacts _or_ production code, depending on the need.

## Quick orientation

- **Brand color:** violet `#7C5CBF` (primary). Logo is a tri-color triskel (magenta/yellow/cyan), used only as the mark.
- **Type:** `DM Serif Display` for headings + wordmark, `DM Sans` for everything else. Loaded from Google Fonts.
- **Two surfaces, two patterns:**
  - Teacher panel = desktop sidebar app. Flat cards. Spanish, voseo, tells Amira what to do.
  - Student panel = mobile bottom-nav app, max-width 480, sticky header. Floating violet-tinted shadow cards. First-person Spanish.
- **Iconography:** production is **emoji** (🏠 👤 📅 📝 📚 💰 💬 🌿). Lucide is recommended as the upgrade path; flag the substitution.
- **Modality colors:** Reformer = blue, Mat = green, Funcional = amber. Never mix them up.
- **Money:** Argentine peso, `$12.500` (period thousands), no decimals.
- **WhatsApp voice:** voseo, 🌿 brand sign-off, "¡Gracias!" not "Gracias.", never formal usted.

## What's in here

- `README.md` — full brand bible: content fundamentals, visual foundations, iconography.
- `colors_and_type.css` — all CSS custom properties, ready to `@import`.
- `assets/logo-triskel.png`, `assets/logo.jpeg` — the two logo variants.
- `ui_kits/teacher-panel/` — desktop sidebar app components + screens.
- `ui_kits/student-panel/` — mobile bottom-nav app components + screens.
- `preview/*.html` — 21 design-system cards covering tokens & components.

## When designing a new screen

1. Decide which panel context applies (teacher / student / new). The two have **different shadow + card patterns** — don't mix.
2. Copy `colors_and_type.css` into your output and use the tokens — no new colors.
3. Pull a starting component from `ui_kits/<surface>/*Primitives.jsx` or `*Screens.jsx`.
4. Use real assets from `assets/`, never draw new SVGs for the logo.
5. Use emoji icons unless the user explicitly asked for "more professional" / "Lucide" — in which case swap per the README ICONOGRAPHY mapping.
6. Write copy in **Argentine Spanish, voseo**. Use Amira's first name, not "the teacher".

## Common output formats

- Slide / static mock → make a single HTML file, `@import` the CSS, drop in the logo.
- Interactive prototype → load React+Babel, import the `*Primitives.jsx` + `*Screens.jsx` from the matching UI kit (e.g. `TeacherPrimitives.jsx`, `StudentScreens.jsx`), build new screens that compose those primitives.
- Production guidance / handoff → read the README sections directly into your output.
