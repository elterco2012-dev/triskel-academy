import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';

const SUPABASE_URL = Deno.env.get('SUPABASE_URL')!;
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
    const { alumna_id, email, password } = await req.json();

    if (!alumna_id || !email || !password) {
      return json({ ok: false, msg: 'alumna_id, email y password son requeridos' }, 400);
    }

    // Check if user already exists
    const { data: existing } = await admin.auth.admin.listUsers();
    const alreadyExists = existing?.users?.find(u => u.email === email);

    let userId: string;

    if (alreadyExists) {
      // Update password if user already exists
      const { data: updated, error: updateErr } = await admin.auth.admin.updateUserById(
        alreadyExists.id,
        { password }
      );
      if (updateErr) return json({ ok: false, msg: updateErr.message }, 400);
      userId = alreadyExists.id;
    } else {
      // Create new auth user
      const { data: created, error: createErr } = await admin.auth.admin.createUser({
        email,
        password,
        email_confirm: true,  // skip confirmation email
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
    return json({ ok: false, msg: String(e) }, 500);
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
