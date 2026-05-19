import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';

const SUPABASE_URL        = Deno.env.get('SUPABASE_URL')!;
const SUPABASE_SERVICE_KEY = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!;

const admin = createClient(SUPABASE_URL, SUPABASE_SERVICE_KEY, {
  auth: { autoRefreshToken: false, persistSession: false }
});

Deno.serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response(null, {
      headers: {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Headers': 'authorization, content-type',
      }
    });
  }

  try {
    // Verify the caller is authenticated and is NOT an alumna
    const authHeader = req.headers.get('Authorization');
    if (!authHeader) return json({ ok: false, msg: 'not authenticated' }, 401);

    const token = authHeader.replace('Bearer ', '');
    const { data: { user }, error: authErr } = await admin.auth.getUser(token);
    if (authErr || !user) return json({ ok: false, msg: 'invalid token' }, 401);

    // Block alumnas from calling this endpoint
    const { data: alumnaRecord } = await admin
      .from('triskel_alumnas')
      .select('id')
      .eq('auth_user_id', user.id)
      .maybeSingle();

    if (alumnaRecord) return json({ ok: false, msg: 'no autorizado' }, 403);

    const { alumna_id, email, password } = await req.json();
    if (!alumna_id || !email || !password) {
      return json({ ok: false, msg: 'alumna_id, email y password son requeridos' }, 400);
    }

    // Use getUserByEmail instead of listing all users
    let userId: string;
    const { data: existingUser } = await admin.auth.admin.getUserByEmail(email);

    if (existingUser?.user) {
      const { error: updateErr } = await admin.auth.admin.updateUserById(
        existingUser.user.id,
        { password }
      );
      if (updateErr) return json({ ok: false, msg: updateErr.message }, 400);
      userId = existingUser.user.id;
    } else {
      const { data: created, error: createErr } = await admin.auth.admin.createUser({
        email,
        password,
        email_confirm: true,
      });
      if (createErr) return json({ ok: false, msg: createErr.message }, 400);
      userId = created.user!.id;
    }

    // Link auth_user_id to alumna record
    const { error: linkErr } = await admin
      .from('triskel_alumnas')
      .update({ auth_user_id: userId })
      .eq('id', alumna_id);

    if (linkErr) return json({ ok: false, msg: linkErr.message }, 400);

    return json({ ok: true, user_id: userId });
  } catch (e) {
    console.error(e);
    return json({ ok: false, msg: 'internal error' }, 500);
  }
});

function json(data: unknown, status = 200) {
  return new Response(JSON.stringify(data), {
    status,
    headers: {
      'Content-Type': 'application/json',
      'Access-Control-Allow-Origin': '*',
    },
  });
}
