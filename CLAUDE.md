# Triskel Academy — Contexto del proyecto

## Qué es y para quién

App web PWA para **Lorena**, profesora de pilates que gestiona un estudio small (Triskel Academy). Tiene ~42 alumnas, varias modalidades (reformer, mat, funcional) y necesita manejar: inscripciones, cobros, ausencias, asistencia y clases planificadas — todo desde el celular.

**Dos roles:**
- **Profe (Lorena):** panel completo en `panel/index.html` — gestión total
- **Alumnas:** app simplificada en `panel/alumna.html` — ver su ficha, avisar pagos, avisar ausencias, ver clase planificada

Está en producción en: `https://triskel-academy.vercel.app`

---

## Arquitectura de archivos

```
panel/
  index.html        ← Panel de la profe (SPA completa, ~6000 líneas)
  alumna.html       ← App de las alumnas (SPA, ~1400 líneas)
  sw.js             ← Service worker del panel de profe (push + cache)
  sw-alumna.js      ← Service worker de la app de alumnas
  manifest.json     ← PWA manifest del panel de profe
  guia.html         ← Landing de onboarding para alumnas (cómo instalar la app)
  instalar.html     ← Wizard paso a paso para instalar la PWA (Android/iOS)
  guia-profe.html   ← Guía para Lorena con mockups de los 4 flujos del día a día

supabase/
  functions/
    send-push/index.ts         ← Edge Function: envía push notifications
    setup-alumna-auth/index.ts ← Edge Function: crea/actualiza auth de alumnas

migrations/
  001 a 045_*.sql   ← Historial completo de cambios de schema y funciones SQL

index.html          ← Redirect a panel/index.html (landing pública)
manifest.json       ← PWA manifest raíz
```

---

## Tecnologías

| Capa | Tecnología |
|---|---|
| Frontend | HTML/CSS/JS vanilla — **sin frameworks**. Todo en un único archivo HTML por app. |
| Backend | **Supabase** (PostgreSQL + Auth + Edge Functions + Storage) |
| Edge Functions | **Deno** (TypeScript) en Supabase |
| Push notifications | **web-push** (`npm:web-push@3.6.7`) + VAPID |
| Crons | **pg_cron** (extensión PostgreSQL en Supabase) |
| HTTP desde SQL | **pg_net** (`net.http_post`) para llamar Edge Functions desde SQL |
| Deploy | **Vercel** (static hosting) |
| Auth | Supabase Auth (email+password, sin OTP) |

---

## Configuración y credenciales

**Supabase project:** `dplzkrdgnynyyunmrawr`
**URL:** `https://dplzkrdgnynyyunmrawr.supabase.co`

Las claves están hardcodeadas en los HTML (es una app single-tenant, no es un SaaS):
- `SB_KEY` en `panel/index.html:884` y `panel/alumna.html:320` → anon key pública
- Service role key → hardcodeada en migrations `040_fix_cron_service_key.sql` dentro de las funciones SQL que llaman Edge Functions via `net.http_post`

**VAPID keys** para push:
- Public: `BEXtjaNEQhKEN8rEGQAp0NhcpFsAfl7vWrTCJTMUdOrNf6iOvmkdFIUEOcchkkNoJoixRdqLheqrIkjwQEAIw28`
- Private: en Supabase → Edge Functions → Secrets → `VAPID_PRIVATE_KEY`
- Email VAPID: `mailto:aaron_armoa@hotmail.com`

**Crons (pg_cron, horario UTC):**
- `triskel-payment-reminders`: `0 12 * * *` (9 AM Argentina) → `triskel_send_payment_reminders()`
- `triskel-cumpleanos`: `0 11 * * *` (8 AM Argentina) → `triskel_send_birthday_reminders()`
- `triskel-payment-reminders-followup`: otro cron de recordatorios de seguimiento

**Verificar crons activos:**
```sql
SELECT jobname, schedule, active FROM cron.job WHERE jobname LIKE 'triskel-%';
SELECT jobid, status, start_time, command FROM cron.job_run_details ORDER BY start_time DESC LIMIT 10;
```

---

## Schema de la base de datos

**Tablas principales** (todas con prefijo `triskel_`):

| Tabla | Descripción |
|---|---|
| `triskel_alumnas` | Datos de alumnas: nombre, apellido, tel, email, dni, fecha_nacimiento, estado, auth_user_id, dia_pago, contraindicaciones |
| `triskel_horarios` | Horarios/clases: modalidad (reformer/mat/funcional), dia, hora_inicio, capacidad, activo, notas |
| `triskel_inscripciones` | Alumna ↔ horario: alumna_id, horario_id, precio, activa |
| `triskel_clases` | Clases planificadas: horario_id, fecha, ejercicios (jsonb), notas |
| `triskel_pagos` | Pagos: alumna_id, inscripcion_id, mes (YYYY-MM), monto, pagado |
| `triskel_avisos_pago` | Avisos de pago enviados por alumnas: alumna_id, mes, monto, medio, estado (pendiente/aprobado/rechazado) |
| `triskel_ausencias` | Ausencias avisadas: alumna_id, inscripcion_id, fecha, motivo |
| `triskel_push_subscriptions` | Suscripciones push: user_id, tipo (teacher/alumna), subscription (jsonb) |
| `triskel_fichas_salud` | Ficha de salud de la alumna: campos médicos, contraindicaciones |
| `triskel_observaciones` | Notas libres sobre alumnas |
| `triskel_banco_ejercicios` | Banco de ejercicios para planificar clases |
| `triskel_configuracion` | Key/value de configuración del sistema |
| `triskel_lista_espera` | Lista de espera por horario (legacy — ver nota abajo) |

**RLS:** todas las tablas tienen Row Level Security habilitada.
**Seguridad:** función `triskel_is_alumna()` detecta si el usuario auth es una alumna → bloquea operaciones de escritura sensibles.

---

## Decisiones técnicas importantes

### 1. Sin frameworks — todo en un HTML
Decisión consciente para simplificar el deploy (Vercel static), evitar build steps, y mantener cero dependencias. El costo es archivos largos (~6000 líneas) pero el beneficio es simplicidad total de operación.

### 2. DNI como credencial de login
Las alumnas usan su DNI como usuario (no email). Internamente se convierte a `{dni}@triskel.local` para el sistema de auth de Supabase. La función `normalizeLoginEmail()` en `alumna.html:350` hace la conversión. Si una alumna también tiene email real, el DNI siempre tiene prioridad como auth credential.
- **Nunca** mostrar `@triskel.local` en la UI (filtrar con `.endsWith('@triskel.local')`)
- Auth email se guarda como `{dni}@triskel.local`; el email real se guarda en la columna `email` de la tabla

### 3. Precios de inscripción
El sistema **suma** los precios de inscripciones del mismo grupo (alumna + modalidad) para calcular la cuota mensual. Por lo tanto, si una alumna va 2 días de Reformer ($37.000/mes), cada inscripción debe tener precio `$18.500` (la mitad). Ver `migration 044`.

Precios actuales:
- Reformer: 1 día $31.000 / 2 días $37.000
- Mat: 1 día $27.000 / 2 días $33.000
- Funcional: 1 día $27.000 / 2 días $33.000 / 3 días $39.000

### 4. Push notifications — autorización en send-push
La Edge Function `send-push` verifica si el caller es service_role **decodificando el JWT y chequeando el claim `role`**, NO comparando el token string completo. El string comparison causaba 401 cuando se llamaba desde `net.http_post`. Fix aplicado en `supabase/functions/send-push/index.ts`.

```typescript
// CORRECTO — verificar por claim
const jwtPayload = JSON.parse(atob(token.split('.')[1]));
isServiceRole = jwtPayload.role === 'service_role';

// INCORRECTO — comparación string que fallaba
// isServiceRole = token === SUPABASE_SERVICE_KEY;
```

### 5. Multi-device push (migration 032)
Un usuario puede tener múltiples suscripciones push (varios dispositivos/browsers). La Edge Function envía a todos y elimina automáticamente los endpoints con status 410 (expirados). Si las notificaciones dejan de llegar, probablemente las suscripciones expiraron → la profe/alumna debe abrir el panel para re-registrar.

### 6. triskel_save_alumna — única firma
La función tenía dos firmas coexistentes (10 y 11 parámetros) causando "Could not choose best candidate function". Se resolvió con `migration 041` que dropea la firma vieja. La firma actual (11 params con `p_dni`) está en `migration 039`.

---

## Features implementados

### Panel de la profe (`panel/index.html`)
- **Inicio:** avisos de pago pendientes (confirmar/rechazar), cumpleaños del día, alumnas sin pago del mes
- **Alumnas:** listado con buscador, ficha individual (historial de pagos, inscripciones, observaciones, foto)
- **Horarios:** grilla visual semanal con barra de ocupación por color. Click en un horario abre detalle con lista de alumnas inscriptas y campo de notas libres (lista de espera informal)
- **Planificar (Clases):** planificar ejercicios por clase para una fecha, banco de ejercicios
- **Historial:** vista de asistencia histórica
- **Planes:** gestión de precios/planes por modalidad
- **Pagos:** registro de pagos, envío de recordatorios manuales y automáticos
- **Biblioteca:** banco de ejercicios categorizados

### App de alumnas (`panel/alumna.html`)
- Login con DNI (número puro, sin email)
- Ficha personal: próximas clases, historial de pagos
- Avisar pago (push notification a la profe)
- Avisar ausencia (selección de clase + motivo)
- Ver ejercicios planificados para su próxima clase
- Completar ficha de salud
- Foto de perfil

### Notificaciones push
Tipos implementados en `send-push`:
- `aviso_pago` — alumna avisó que pagó → profe
- `recordatorio_pago` — cron automático → alumna
- `recordatorio_manual` — profe manda manualmente → alumna
- `pago_aprobado` / `pago_rechazado` — profe confirma → alumna
- `ausencia` — alumna avisó ausencia → profe
- `clase_planificada` — profe planificó clase → alumna
- `ficha_completada` — alumna completó ficha → profe
- `cumpleanos` — cron automático → profe (para saludar a la alumna)

### Páginas de onboarding
- `panel/guia.html` — landing con link clickeable + instrucciones de instalación (2 líneas Android, 2 líneas iOS)
- `panel/instalar.html` — wizard interactivo paso a paso, auto-detecta Android/iOS
- `panel/guia-profe.html` — guía para Lorena con mockups de los 4 flujos del día a día

---

## Cosas que NO hacer

- **No usar QR codes** en materiales para alumnas — tienen un solo celular y no pueden escanear desde el mismo dispositivo
- **No ofrecer "cambiar contraseña" a las alumnas** — la contraseña es la fecha de nacimiento en formato `ddmmaa` (ej: 261188), no hay cambio de clave por ahora
- **No comparar service_role JWT como string** en Edge Functions — siempre decodificar y verificar el claim `role`
- **No crear dos firmas de la misma función SQL** — Supabase/PostgREST no puede resolver la ambigüedad → "could not choose best candidate function"
- **No usar `auto-fill` en CSS Grid** cuando hay columnas vacías — usar `auto-fit` para que los tracks vacíos colapsen
- **No mostrar `@triskel.local`** en la UI — siempre filtrar con `.endsWith('@triskel.local')`
- **No hardcodear precios como totales** cuando hay múltiples inscripciones — el sistema suma, entonces dividir el total entre cantidad de días

---

## Usuarios del sistema

- **Lorena (profe):** usuario creado manualmente en Supabase Dashboard → Authentication → Users. Email: el suyo real. Contraseña: acordada con ella. NO aparece en `triskel_alumnas`.
- **Alumnas:** creadas via `setup-alumna-auth` Edge Function. Auth email = `{dni}@triskel.local`. Contraseña = fecha de nacimiento `ddmmaa`. Vinculadas por `auth_user_id` en `triskel_alumnas`.

---

## Tareas pendientes / trabajo en progreso

### Pendiente de ejecutar en Supabase SQL Editor
Estas migrations están escritas pero pueden no haberse ejecutado aún:
- `041_drop_old_save_alumna.sql` — dropear firma vieja de `triskel_save_alumna`
- `042_import_alumnas.sql` — importar ~42 alumnas desde Excel
- `043_crear_accesos_alumnas.sql` — crear cuentas auth para las alumnas importadas
- `044_precios_inscripciones.sql` — actualizar precios según modalidad y días
- `045_horario_notas.sql` — agregar campo `notas` a `triskel_horarios`

### Pendiente de data
- 8-11 alumnas cuyos datos no estaban completos al momento del import masivo
- Cuenta de Lorena en Supabase Auth (si no está creada)

### Trabajo en progreso
- **Branch activo:** `claude/fix-error-URevQ` — contiene el fix del 401 en send-push
- Push notification de cumpleaños: la infraestructura funciona, pero si las suscripciones push de la profe expiran (410), hay que abrir el panel para re-registrarlas

---

## Problemas conocidos y soluciones

| Problema | Causa | Solución |
|---|---|---|
| "Could not choose best candidate function" al editar alumna | Dos firmas de `triskel_save_alumna` coexistiendo | Ejecutar `041_drop_old_save_alumna.sql` |
| Push notification no llega aunque el cron ejecutó | Suscripción push expirada (status 410) | Abrir el panel para re-registrar; el SW registra nueva suscripción automáticamente |
| Push notification 401 desde net.http_post | Comparación string del JWT fallaba en Edge Function | Fix ya en código: verificar por claim `role === 'service_role'` |
| `cron.job_run_details` — "column jobname does not exist" | En Supabase pg_cron la columna es `command`, no `jobname` | Usar `SELECT jobid, status, command FROM cron.job_run_details` |
| Columna gris vacía en grilla de Planificar | CSS Grid con `auto-fill` crea tracks vacíos | Usar `auto-fit` en lugar de `auto-fill` |
| `net._http_response` — tabla no accesible | Tabla interna de pg_net, sin permisos por defecto | Verificar Edge Function logs en Supabase Dashboard |

---

## Cómo correr localmente

No hay build step. Los archivos HTML son estáticos. Para desarrollo:
1. Cualquier servidor estático local sirve (ej: `python3 -m http.server 8080` desde la raíz)
2. Las llamadas a Supabase apuntan siempre a producción (no hay entorno local de Supabase configurado)
3. Para deployar Edge Functions: `supabase functions deploy send-push --project-ref dplzkrdgnynyyunmrawr`

Para que las push notifications funcionen en local se necesita HTTPS (las APIs de SW requieren origen seguro). Usar ngrok o similar si se quiere testear push localmente.
