-- Migración 025: Registro de asistencia por clase
-- Ejecutar en Supabase SQL Editor

-- Tabla principal
create table if not exists triskel_asistencia (
  id bigserial primary key,
  clase_id bigint not null references triskel_clases(id) on delete cascade,
  alumna_id bigint not null references triskel_alumnas(id) on delete cascade,
  presente boolean not null default true,
  created_at timestamptz not null default now(),
  unique(clase_id, alumna_id)
);

-- Índices para consultas frecuentes
create index if not exists triskel_asistencia_clase_idx on triskel_asistencia(clase_id);
create index if not exists triskel_asistencia_alumna_idx on triskel_asistencia(alumna_id);

-- RPC: guardar asistencia de una clase (reemplaza toda la asistencia existente)
create or replace function triskel_save_asistencia(
  p_clase_id bigint,
  p_presentes bigint[]
) returns jsonb
language plpgsql security definer as $$
begin
  delete from triskel_asistencia where clase_id = p_clase_id;
  if array_length(coalesce(p_presentes, array[]::bigint[]), 1) > 0 then
    insert into triskel_asistencia (clase_id, alumna_id, presente)
    select p_clase_id, unnest(p_presentes), true;
  end if;
  return jsonb_build_object('ok', true);
end;$$;

-- RPC: obtener asistencia (últimos 3 meses por defecto, o filtrada)
create or replace function triskel_get_asistencia(
  p_alumna_id bigint default null,
  p_desde date default null,
  p_hasta date default null
) returns jsonb
language plpgsql security definer as $$
declare
  v_desde date := coalesce(p_desde, (current_date - interval '90 days')::date);
  v_hasta date := coalesce(p_hasta, current_date);
  v_result jsonb;
begin
  select jsonb_agg(jsonb_build_object(
    'clase_id', a.clase_id,
    'alumna_id', a.alumna_id,
    'presente', a.presente,
    'fecha', c.fecha
  ) order by c.fecha desc)
  into v_result
  from triskel_asistencia a
  join triskel_clases c on c.id = a.clase_id
  where (p_alumna_id is null or a.alumna_id = p_alumna_id)
    and c.fecha >= v_desde
    and c.fecha <= v_hasta;

  return jsonb_build_object('ok', true, 'data', coalesce(v_result, '[]'::jsonb));
end;$$;
