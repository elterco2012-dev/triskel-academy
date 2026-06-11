import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';
import webpush from 'npm:web-push@3.6.7';

const SUPABASE_URL        = Deno.env.get('SUPABASE_URL')!;
const SUPABASE_SERVICE_KEY = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!;
const VAPID_PUBLIC  = 'BEXtjaNEQhKEN8rEGQAp0NhcpFsAfl7vWrTCJTMUdOrNf6iOvmkdFIUEOcchkkNoJoixRdqLheqrIkjwQEAIw28';
const VAPID_PRIVATE = Deno.env.get('VAPID_PRIVATE_KEY')!;
const VAPID_EMAIL   = 'mailto:aaron_armoa@hotmail.com';

webpush.setVapidDetails(VAPID_EMAIL, VAPID_PUBLIC, VAPID_PRIVATE);
const sb = createClient(SUPABASE_URL, SUPABASE_SERVICE_KEY);

interface PushPayload {
  tipo: string;
  target_user_id?: string;
  target_tipo?: string;
  nombre?: string;
  mes?: string;
  monto?: number;
  nota?: string;
  clase?: string;
  fecha?: string;
  motivo?: string;
}

// Tipos que una alumna autenticada puede enviar (siempre hacia 'teacher')
const ALUMNA_ALLOWED = ['aviso_pago', 'ausencia', 'ficha_completada'];

const TITLES: Record<string, string> = {
  aviso_pago:          '💰 Nueva notificación de pago',
  recordatorio_pago:   '⏰ Recordatorio de pago',
  recordatorio_manual: '⏰ Recordatorio de pago',
  pago_aprobado:       '✅ Pago aprobado',
  pago_rechazado:      '❌ Pago pendiente de revisión',
  ausencia:            '📅 Aviso de ausencia',
  clase_planificada:   '📋 Clase planificada',
  ficha_completada:    '📋 Nueva ficha de salud',
  cumpleanos:          '🎂 Cumpleaños hoy',
};

const BODIES: Record<string, (p: PushPayload) => string> = {
  aviso_pago:          (p) => `${p.nombre} avisó que pagó ${p.mes ? `(${mesLabel(p.mes)})` : ''} ${p.monto ? `· $${p.monto.toLocaleString('es-AR')}` : ''}`.trim(),
  recordatorio_pago:   (p) => `Hola ${p.nombre}! Recordá abonar tu cuota de ${mesLabel(p.mes||'')}. 🌿`,
  recordatorio_manual: (p) => `Hola ${p.nombre}! Tu profe te manda un recordatorio de pago de ${mesLabel(p.mes||'')}. 🌿`,
  pago_aprobado:       (p) => `¡Tu pago de ${mesLabel(p.mes||'')} fue aprobado! ✅`,
  pago_rechazado:      (p) => `Tu aviso de pago de ${mesLabel(p.mes||'')} está siendo revisado.`,
  ausencia:            (p) => `${p.nombre} avisó que no puede ir el ${p.fecha||''} · ${p.clase||''}${p.motivo ? ` — ${p.motivo}` : ''}`,
  clase_planificada:   (p) => `Tu clase de ${p.clase||''} del ${p.fecha||''} ya tiene ejercicios cargados. ¡A entrenar! 💪`,
  ficha_completada:    (p) => `${p.nombre} completó su ficha de salud. Revisala cuando puedas.`,
  cumpleanos:          (p) => `¡Hoy cumple años ${p.nombre}! 🎂 No te olvides de saludarla.`,
};

function mesLabel(mes: string): string {
  if (!mes) return '';
  const [y, m] = mes.split('-');
  return new Date(Number(y), Number(m) - 1, 1).toLocaleDateString('es-AR', { month: 'long', year: 'numeric' });
}

Deno.serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response(null, {
      headers: { 'Access-Control-Allow-Origin': '*', 'Access-Control-Allow-Headers': 'authorization, content-type' }
    });
  }

  try {
    const authHeader = req.headers.get('Authorization');
    if (!authHeader) return json({ ok: false, msg: 'not authenticated' }, 401);

    const token = authHeader.replace('Bearer ', '');
    // Decode JWT and check role claim (more robust than string comparison)
    let isServiceRole = false;
    try {
      const jwtPayload = JSON.parse(atob(token.split('.')[1]));
      isServiceRole = jwtPayload.role === 'service_role';
    } catch {
      isServiceRole = token === SUPABASE_SERVICE_KEY;
    }

    let alumnaRecord: { id: number; nombre: string; apellido: string } | null = null;
    if (!isServiceRole) {
      const { data: { user }, error: authErr } = await sb.auth.getUser(token);
      if (authErr || !user) return json({ ok: false, msg: 'invalid token' }, 401);

      const { data } = await sb
        .from('triskel_alumnas')
        .select('id, nombre, apellido')
        .eq('auth_user_id', user.id)
        .maybeSingle();
      alumnaRecord = data;
    }

    const payload: PushPayload = await req.json();
    const { tipo, target_user_id, target_tipo } = payload;

    if (!TITLES[tipo]) return json({ ok: false, msg: 'tipo invalido' }, 400);

    if (alumnaRecord) {
      if (!ALUMNA_ALLOWED.includes(tipo)) return json({ ok: false, msg: 'no autorizado' }, 403);
      if (target_tipo !== 'teacher') return json({ ok: false, msg: 'no autorizado' }, 403);
      payload.nombre = alumnaRecord.nombre;
    }

    let query = sb.from('triskel_push_subscriptions').select('*');
    if (target_user_id) {
      query = query.eq('user_id', target_user_id);
    } else if (target_tipo) {
      query = query.eq('tipo', target_tipo);
    } else {
      return json({ ok: false, msg: 'target_user_id or target_tipo required' }, 400);
    }

    const { data: subs, error } = await query;
    if (error) throw error;
    if (!subs || subs.length === 0) return json({ ok: true, sent: 0, msg: 'no subscriptions' });

    const title = TITLES[tipo] || 'Triskel Academy';
    const body  = BODIES[tipo]?.(payload) || '';
    const notification = JSON.stringify({
      title, body,
      icon:  '/panel/logo-triskel.png',
      badge: '/panel/logo-triskel.png',
      data:  { tipo, mes: payload.mes },
    });

    let sent = 0, failed = 0;
    for (const sub of subs) {
      try {
        await webpush.sendNotification(sub.subscription, notification);
        sent++;
      } catch (e: any) {
        console.error('Push failed sub.id', sub.id, e?.statusCode);
        // 410 Gone or 404 = subscription expired/unregistered → delete it
        if (e?.statusCode === 410 || e?.statusCode === 404) {
          await sb.from('triskel_push_subscriptions').delete().eq('id', sub.id);
        }
        failed++;
      }
    }

    return json({ ok: true, sent, failed });
  } catch (e) {
    console.error(e);
    return json({ ok: false, msg: 'internal error' }, 500);
  }
});

function json(data: unknown, status = 200) {
  return new Response(JSON.stringify(data), {
    status,
    headers: { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' },
  });
}
