import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';
import webpush from 'npm:web-push@3.6.7';

const SUPABASE_URL = Deno.env.get('SUPABASE_URL')!;
const SUPABASE_SERVICE_KEY = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!;
const VAPID_PUBLIC = Deno.env.get('VAPID_PUBLIC_KEY')!;
const VAPID_PRIVATE = Deno.env.get('VAPID_PRIVATE_KEY')!;
const VAPID_EMAIL = Deno.env.get('VAPID_EMAIL') || 'mailto:admin@triskelacademy.com';

webpush.setVapidDetails(VAPID_EMAIL, VAPID_PUBLIC, VAPID_PRIVATE);

const sb = createClient(SUPABASE_URL, SUPABASE_SERVICE_KEY);

interface PushPayload {
  tipo: 'aviso_pago' | 'recordatorio_pago' | 'pago_aprobado' | 'pago_rechazado';
  target_user_id?: string;   // send to specific user
  target_tipo?: string;      // send to all users of this tipo ('teacher' | 'alumna')
  nombre?: string;
  mes?: string;
  monto?: number;
  nota?: string;
}

const TITLES: Record<string, string> = {
  aviso_pago: '💰 Nueva notificación de pago',
  recordatorio_pago: '⏰ Recordatorio de pago',
  pago_aprobado: '✅ Pago aprobado',
  pago_rechazado: '❌ Pago pendiente de revisión',
};

const BODIES: Record<string, (p: PushPayload) => string> = {
  aviso_pago: (p) => `${p.nombre} avisó que pagó ${p.mes ? `(${mesLabel(p.mes)})` : ''} ${p.monto ? `· $${p.monto.toLocaleString('es-AR')}` : ''}`.trim(),
  recordatorio_pago: (p) => `Hola ${p.nombre}! Recordá abonar tu cuota de ${mesLabel(p.mes||'')}. 🌿`,
  pago_aprobado: (p) => `¡Tu pago de ${mesLabel(p.mes||'')} fue aprobado! ✅`,
  pago_rechazado: (p) => `Tu aviso de pago de ${mesLabel(p.mes||'')} está siendo revisado.`,
};

function mesLabel(mes: string): string {
  if (!mes) return '';
  const [y, m] = mes.split('-');
  return new Date(Number(y), Number(m) - 1, 1).toLocaleDateString('es-AR', { month: 'long', year: 'numeric' });
}

Deno.serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response(null, { headers: { 'Access-Control-Allow-Origin': '*', 'Access-Control-Allow-Headers': 'authorization, content-type' } });
  }

  try {
    const payload: PushPayload = await req.json();
    const { tipo, target_user_id, target_tipo } = payload;

    // Fetch subscriptions
    let query = sb.from('triskel_push_subscriptions').select('*');
    if (target_user_id) {
      query = query.eq('user_id', target_user_id);
    } else if (target_tipo) {
      query = query.eq('tipo', target_tipo);
    } else {
      return new Response(JSON.stringify({ error: 'target_user_id or target_tipo required' }), { status: 400 });
    }

    const { data: subs, error } = await query;
    if (error) throw error;
    if (!subs || subs.length === 0) {
      return new Response(JSON.stringify({ ok: true, sent: 0, msg: 'no subscriptions found' }));
    }

    const title = TITLES[tipo] || 'Triskel Academy';
    const body = BODIES[tipo]?.(payload) || '';
    const notification = JSON.stringify({ title, body, icon: '/panel/icon-192.png', badge: '/panel/icon-192.png', data: { tipo, mes: payload.mes } });

    let sent = 0;
    let failed = 0;
    for (const sub of subs) {
      try {
        await webpush.sendNotification(sub.subscription, notification);
        sent++;
      } catch (e) {
        console.error('Push failed for', sub.user_id, e);
        // Remove expired subscriptions (410 Gone)
        if ((e as any).statusCode === 410) {
          await sb.from('triskel_push_subscriptions').delete().eq('user_id', sub.user_id);
        }
        failed++;
      }
    }

    return new Response(JSON.stringify({ ok: true, sent, failed }), {
      headers: { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' },
    });
  } catch (e) {
    console.error(e);
    return new Response(JSON.stringify({ error: String(e) }), { status: 500 });
  }
});
