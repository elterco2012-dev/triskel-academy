// data.js — sample fixture data for the student panel kit
// Shape mirrors what `triskel_get_mi_ficha` returns from Supabase.

window.SP_FIXTURE = {
  alumna: {
    nombre: "María González",
    email: "maria.gonzalez@gmail.com",
    tel: "5491140012345",
    dia_pago: 10,
    nacimiento: "1988-03-21",
    foto: null,
  },
  inscripciones: [
    { id: 1, modalidad: "reformer", dia: "lun", horario: "09:30–10:30", plan_nombre: "Plan 2 días" },
    { id: 2, modalidad: "reformer", dia: "mie", horario: "09:30–10:30", plan_nombre: "Plan 2 días" },
    { id: 3, modalidad: "mat",      dia: "vie", horario: "18:00–19:00", plan_nombre: null },
  ],
  // Current month default: pending (no aviso yet) → "Sin pago registrado"
  pagos: [
    { mes: "2025-10", pagado: true, monto: 25000, nota: "Transferencia 8/10" },
    { mes: "2025-09", pagado: true, monto: 25000, nota: null },
    { mes: "2025-08", pagado: true, monto: 25000, nota: null },
    { mes: "2025-07", pagado: true, monto: 22000, nota: null },
  ],
  avisos: [],
};

window.SP_DIA_LABEL = {
  lun: "Lunes", mar: "Martes", mie: "Miércoles", jue: "Jueves", vie: "Viernes",
};
window.SP_DIA_ORDER = { lun: 0, mar: 1, mie: 2, jue: 3, vie: 4 };
window.SP_MOD_COLOR = {
  mat:        "#27ae60",
  reformer:   "#2980b9",
  funcional:  "#e67e22",
};
window.SP_MOD_CHIP = {
  mat:       "sp-chip-mat",
  reformer:  "sp-chip-reformer",
  funcional: "sp-chip-funcional",
};
window.SP_MOD_LABEL = {
  mat:        "Mat",
  reformer:   "Reformer",
  funcional:  "Funcional",
};

window.SP_mesLabel = (mesStr) => {
  if (!mesStr) return "";
  const [y, m] = mesStr.split("-");
  return new Date(y, m - 1, 1).toLocaleDateString("es-AR", { month: "long", year: "numeric" });
};
window.SP_mesActual = () => new Date().toISOString().slice(0, 7);
window.SP_money = (n) => "$" + Number(n || 0).toLocaleString("es-AR");
