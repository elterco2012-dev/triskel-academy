# HANDOFF — Triskel Academy
**Fecha:** 2026-06-12  
**Branch de trabajo:** `claude/fix-error-URevQ`  
**Sesión:** migración de cuenta — trabajo completo a salvo en este branch

---

## Resumen de la sesión

Esta sesión arrancó con el panel ya funcional y se concentró en:
1. Completar el sistema de login por DNI para alumnas
2. Importar ~42 alumnas desde Excel con inscripciones y precios
3. Mejorar UX del panel (horarios, planificar)
4. Agregar pages de onboarding (guia.html, instalar.html, guia-profe.html)
5. Diagnosticar y corregir bug crítico de push notifications (401 → 410)

---

## Estado actual

### ✅ Completado y pusheado

| Feature | Archivo / Migration |
|---|---|
| Login por DNI en alumna.html | `panel/alumna.html:350` — `normalizeLoginEmail()` |
| DNI como campo en triskel_alumnas | `migrations/039_dni_alumna.sql` |
| Fix firma duplicada de triskel_save_alumna | `migrations/041_drop_old_save_alumna.sql` |
| Import masivo 42 alumnas desde Excel | `migrations/042_import_alumnas.sql` |
| Crear cuentas auth para alumnas | `migrations/043_crear_accesos_alumnas.sql` |
| Precios por modalidad/días divididos | `migrations/044_precios_inscripciones.sql` |
| Campo notas en triskel_horarios (lista de espera) | `migrations/045_horario_notas.sql` |
| Horarios: grilla rediseñada con barra de ocupación | `panel/index.html` — sección horarios |
| Planificar: fix columna gris vacía (auto-fill → auto-fit) | `panel/index.html` — grid planificar |
| Landing onboarding alumnas | `panel/guia.html` |
| Wizard instalación PWA paso a paso | `panel/instalar.html` |
| Guía profe con mockups 4 flujos | `panel/guia-profe.html` |
| **Fix 401 en send-push desde net.http_post** | `supabase/functions/send-push/index.ts` |
| Contexto completo del proyecto | `CLAUDE.md` |

### ⚠️ Completado en código pero PENDIENTE de ejecutar en Supabase

Las siguientes migrations están **escritas y commiteadas** pero hay que correrlas manualmente en Supabase SQL Editor. No hay certeza de cuáles se ejecutaron ya:

```
041_drop_old_save_alumna.sql   ← DROP de la firma vieja (10 params) de triskel_save_alumna
042_import_alumnas.sql         ← Insert de ~42 alumnas con inscripciones
043_crear_accesos_alumnas.sql  ← Crea cuentas auth para cada alumna (DNI → @triskel.local)
044_precios_inscripciones.sql  ← Actualiza precios según modalidad+días
045_horario_notas.sql          ← ADD COLUMN notas a triskel_horarios
```

### ⚠️ Edge Function send-push — PENDIENTE DE DEPLOY

El fix del 401 está en el código local (`supabase/functions/send-push/index.ts`) pero hay que deployarlo en Supabase:

```bash
supabase functions deploy send-push --project-ref dplzkrdgnynyyunmrawr
```

O bien editar el código directamente en Dashboard → Edge Functions → send-push → Code.

El cambio crítico (líneas 70-77 del archivo):
```typescript
// ANTES (fallaba con 401):
const isServiceRole = token === SUPABASE_SERVICE_KEY;

// AHORA (correcto):
let isServiceRole = false;
try {
  const jwtPayload = JSON.parse(atob(token.split('.')[1]));
  isServiceRole = jwtPayload.role === 'service_role';
} catch {
  isServiceRole = token === SUPABASE_SERVICE_KEY;
}
```

### ⚠️ Data pendiente

- 8-11 alumnas con datos incompletos al momento del import — agregar a mano o via `triskel_save_alumna()`
- Cuenta de Lorena en Supabase Auth si no está creada (Dashboard → Authentication → Users)

---

## Tareas pendientes en orden de prioridad

1. **Deploy del Edge Function send-push** (fix del 401 — las push notifications no funcionan sin esto)
2. **Ejecutar migrations 041–045** en Supabase SQL Editor en ese orden
3. **Merge del branch** `claude/fix-error-URevQ` a `main`
4. **Cargar las 8-11 alumnas restantes** con datos completos
5. **Confirmar que Lorena tiene cuenta** en Supabase Auth y puede loguearse al panel
6. **Testear push notifications end-to-end** después del deploy del Edge Function:
   - Lorena abre el panel (re-registra suscripción push)
   - Correr `SELECT triskel_send_birthday_reminders();` en SQL Editor
   - Verificar que llega la notificación

---

## Bug crítico resuelto (documentado para referencia)

### Push notifications daban 401

**Síntoma:** `triskel_send_birthday_reminders()` y `triskel_send_payment_reminders()` corren exitosamente en pg_cron pero no llegan las notificaciones. Edge Function logs muestran `401` en Invocations.

**Causa:** `supabase/functions/send-push/index.ts` comparaba el JWT token completo con el env var `SUPABASE_SERVICE_ROLE_KEY` usando `===`. Cuando la llamada viene de `net.http_post` en PostgreSQL, hay diferencias de encoding que hacen fallar la comparación string.

**Fix:** decodificar el JWT y verificar el claim `role === 'service_role'` en lugar de comparar strings. Ver archivo `supabase/functions/send-push/index.ts` líneas 70-77.

**Estado:** fix en código, **pendiente deploy**.

### Segundo problema: suscripciones push expiradas (410)

**Síntoma:** después de corregir el 401, la invocación retorna 200 pero el log muestra `Push failed sub.id 54 410`.

**Causa:** el endpoint push del navegador expiró. La Edge Function lo detecta y elimina la suscripción automáticamente (código en líneas 126-130).

**Solución:** la profe/alumna debe abrir el panel en el navegador — el service worker re-registra la suscripción automáticamente.

---

## Configuración y comandos especiales

### Supabase
- **Project ref:** `dplzkrdgnynyyunmrawr`
- **URL:** `https://dplzkrdgnynyyunmrawr.supabase.co`
- **Anon key:** hardcodeada en `panel/index.html:884` y `panel/alumna.html:320`
- **Service role key:** en `migrations/040_fix_cron_service_key.sql` (hardcodeada en funciones SQL)
- **VAPID private key:** Supabase → Edge Functions → Secrets → `VAPID_PRIVATE_KEY`

### Deploy
- Frontend: push a `main` → Vercel auto-deploya
- Edge Functions: `supabase functions deploy <nombre> --project-ref dplzkrdgnynyyunmrawr`

### Correr localmente
```bash
python3 -m http.server 8080  # desde la raíz del repo
# → http://localhost:8080/panel/index.html
# Las llamadas a Supabase van siempre a producción
```

### Verificar crons en Supabase
```sql
-- Ver crons activos
SELECT jobname, schedule, active FROM cron.job WHERE jobname LIKE 'triskel-%';

-- Ver ejecuciones recientes (columna es 'command', NO 'jobname')
SELECT jobid, status, start_time, command FROM cron.job_run_details ORDER BY start_time DESC LIMIT 10;
```

### Verificar suscripciones push
```sql
SELECT id, tipo, updated_at FROM triskel_push_subscriptions WHERE tipo = 'teacher' ORDER BY updated_at DESC;
```

---

## Decisiones técnicas clave (no cambiar sin entender)

1. **DNI como auth credential:** `{dni}@triskel.local` es el email interno de Supabase Auth. Nunca mostrar en UI. `normalizeLoginEmail()` en `alumna.html:350` hace la conversión.
2. **Precios divididos:** el sistema SUMA precios de inscripciones del mismo grupo. Si una alumna va 2 días de Reformer ($37.000), cada inscripción debe tener $18.500. No hardcodear el total.
3. **No `auto-fill` en CSS Grid** para la grilla de planificar — usar `auto-fit` (los tracks vacíos colapsan).
4. **No crear dos firmas de la misma función SQL** — PostgREST no puede resolver la ambigüedad.
5. **Push auth:** siempre verificar por claim JWT, nunca por comparación string del token.

---

## Contexto adicional
Ver `CLAUDE.md` en la raíz del repo para documentación completa del proyecto.
