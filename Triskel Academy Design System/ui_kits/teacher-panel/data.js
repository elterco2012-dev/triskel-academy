// data.js — fixture data for the teacher panel kit
// Shape mirrors the DB.* structures used by panel/index.html.

window.TP_DIA_LABEL = { lun: "Lunes", mar: "Martes", mie: "Miércoles", jue: "Jueves", vie: "Viernes" };
window.TP_MOD_LABEL = { mat: "Mat", reformer: "Reformer", funcional: "Funcional" };

const today = new Date();
const mesActual = today.toISOString().slice(0, 7);

window.TP_FIXTURE = {
  mesActual,
  alumnas: [
    { id: 1, nombre: "María",   apellido: "González",   tel: "5491140012345", estado: "activa", dia_pago: 10, nacimiento: "1988-03-21" },
    { id: 2, nombre: "Sofía",   apellido: "Pérez",      tel: "5491140012346", estado: "activa", dia_pago: 5,  nacimiento: "1991-09-14" },
    { id: 3, nombre: "Lucía",   apellido: "Ramírez",    tel: "5491140012347", estado: "activa", dia_pago: 15, nacimiento: "1985-06-30" },
    { id: 4, nombre: "Valentina",apellido:"Acosta",     tel: "5491140012348", estado: "activa", dia_pago: 20, nacimiento: "1994-11-02" },
    { id: 5, nombre: "Camila",  apellido: "Soto",       tel: "5491140012349", estado: "activa", dia_pago: 1,  nacimiento: "1990-04-18" },
    { id: 6, nombre: "Florencia",apellido:"Méndez",     tel: "5491140012350", estado: "activa", dia_pago: 8,  nacimiento: "1987-12-09" },
    { id: 7, nombre: "Renata",  apellido: "Bianchi",    tel: "5491140012351", estado: "pausada", dia_pago: 12 },
    { id: 8, nombre: "Antonella",apellido:"Ferreyra",   tel: "5491140012352", estado: "activa", dia_pago: 25, nacimiento: "1992-07-22" },
  ],
  horarios: [
    { id: 1,  dia: "lun", hora_inicio: "08:00", hora_fin: "09:00", modalidad: "reformer",  capacidad: 4 },
    { id: 2,  dia: "lun", hora_inicio: "09:30", hora_fin: "10:30", modalidad: "reformer",  capacidad: 4 },
    { id: 3,  dia: "lun", hora_inicio: "18:00", hora_fin: "19:00", modalidad: "mat",       capacidad: 6 },
    { id: 4,  dia: "mar", hora_inicio: "08:00", hora_fin: "09:00", modalidad: "funcional", capacidad: 8 },
    { id: 5,  dia: "mar", hora_inicio: "18:00", hora_fin: "19:00", modalidad: "reformer",  capacidad: 4 },
    { id: 6,  dia: "mie", hora_inicio: "09:30", hora_fin: "10:30", modalidad: "reformer",  capacidad: 4 },
    { id: 7,  dia: "mie", hora_inicio: "18:00", hora_fin: "19:00", modalidad: "mat",       capacidad: 6 },
    { id: 8,  dia: "jue", hora_inicio: "08:00", hora_fin: "09:00", modalidad: "funcional", capacidad: 8 },
    { id: 9,  dia: "jue", hora_inicio: "19:00", hora_fin: "20:00", modalidad: "reformer",  capacidad: 4 },
    { id: 10, dia: "vie", hora_inicio: "09:30", hora_fin: "10:30", modalidad: "mat",       capacidad: 6 },
    { id: 11, dia: "vie", hora_inicio: "18:00", hora_fin: "19:00", modalidad: "reformer",  capacidad: 4 },
  ],
  inscripciones: [
    { id: 1,  alumna_id: 1, horario_id: 2,  precio: 12500 },
    { id: 2,  alumna_id: 1, horario_id: 6,  precio: 12500 },
    { id: 3,  alumna_id: 2, horario_id: 3,  precio: 15000 },
    { id: 4,  alumna_id: 2, horario_id: 7,  precio: 15000 },
    { id: 5,  alumna_id: 3, horario_id: 5,  precio: 25000 },
    { id: 6,  alumna_id: 4, horario_id: 1,  precio: 25000 },
    { id: 7,  alumna_id: 4, horario_id: 9,  precio: 25000 },
    { id: 8,  alumna_id: 5, horario_id: 4,  precio: 18000 },
    { id: 9,  alumna_id: 5, horario_id: 8,  precio: 18000 },
    { id: 10, alumna_id: 6, horario_id: 10, precio: 15000 },
    { id: 11, alumna_id: 8, horario_id: 11, precio: 25000 },
    { id: 12, alumna_id: 8, horario_id: 9,  precio: 25000 },
  ],
  pagos: [
    { id: 1, alumna_id: 1, mes: mesActual, monto: 25000, pagado: true, fecha: today.toISOString().slice(0,10) },
    { id: 2, alumna_id: 3, mes: mesActual, monto: 25000, pagado: true, fecha: today.toISOString().slice(0,10) },
    { id: 3, alumna_id: 4, mes: mesActual, monto: 50000, pagado: true, fecha: today.toISOString().slice(0,10) },
    { id: 4, alumna_id: 6, mes: mesActual, monto: 15000, pagado: true, fecha: today.toISOString().slice(0,10) },
  ],
  clases: [
    { id: 1, horario_id: 2, fecha: today.toISOString().slice(0,10), ejercicios: [
      { nombre: "Hundred",            variante: "intermedio" },
      { nombre: "Roll up",            variante: "asistido" },
      { nombre: "Single leg stretch", variante: null },
      { nombre: "Footwork series",    variante: "spring 2 rojos" },
      { nombre: "Short box · round back", variante: null },
      { nombre: "Stretches finales",  variante: null },
    ] },
  ],
};

window.TP_money = (n) => "$" + Number(n || 0).toLocaleString("es-AR");
window.TP_mesLabel = (m) => {
  if (!m) return "";
  const [y, mo] = m.split("-");
  const meses = ["", "Ene","Feb","Mar","Abr","May","Jun","Jul","Ago","Sep","Oct","Nov","Dic"];
  return `${meses[parseInt(mo)]} ${y}`;
};
window.TP_alumnaInits = (n, a) => ((n||"?")[0] + ((a||"")[0]||"")).toUpperCase();
window.TP_inscByAlumna = (db, alumnaId) =>
  db.inscripciones
    .filter(i => i.alumna_id === alumnaId)
    .map(i => ({ ...i, horario: db.horarios.find(h => h.id === i.horario_id) }));
