// Screens.jsx — teacher panel screens
const { useState, useMemo } = React;

// ── Login ───────────────────────────────────────────────────
const TPLogin = ({ onLogin }) => {
  const [email, setEmail] = useState("amira@triskel.com");
  const [pwd, setPwd] = useState("••••••••");
  return (
    <div className="tp-login">
      <div className="tp-login-card">
        <div className="tp-logo"><img src="../../assets/logo-triskel.png" alt="" /></div>
        <h2>Triskel Academy</h2>
        <p>Panel de gestión</p>
        <input className="tp-login-input" type="email"  value={email} onChange={(e)=>setEmail(e.target.value)} />
        <input className="tp-login-input" type="password" value={pwd} onChange={(e)=>setPwd(e.target.value)} onKeyDown={(e) => e.key==='Enter' && onLogin()} />
        <button className="tp-login-btn" onClick={onLogin}>Ingresar</button>
      </div>
    </div>
  );
};

// ── Inicio ──────────────────────────────────────────────────
const TPInicio = ({ db }) => {
  const mes = db.mesActual;
  const activas    = db.alumnas.filter(a => a.estado === "activa");
  const pagosMes   = db.pagos.filter(p => p.mes === mes && p.pagado);
  const pagaron    = new Set(pagosMes.map(p => p.alumna_id)).size;
  const pendientes = activas.length - pagaron;
  const recaudado  = pagosMes.reduce((s, p) => s + (p.monto || 0), 0);

  const modCount = { mat: new Set(), reformer: new Set(), funcional: new Set() };
  db.inscripciones.forEach(i => {
    const h = db.horarios.find(x => x.id === i.horario_id);
    if (h) modCount[h.modalidad]?.add(i.alumna_id);
  });

  // Recordatorios: alumnas activas con cuota vencida o por vencer.
  const diaHoy = new Date().getDate();
  const recordatorios = activas
    .filter(a => a.dia_pago && !pagosMes.find(p => p.alumna_id === a.id))
    .map(a => {
      const diff = diaHoy - a.dia_pago;
      const monto = window.TP_inscByAlumna(db, a.id).reduce((s, i) => s + (i.precio || 0), 0);
      if (diff === 0) return { ...a, monto, tipo: "hoy",      label: "🔴 Vence HOY", color: "var(--status-danger)" };
      if (diff > 0)   return { ...a, monto, tipo: "atrasada", label: `🟠 Atrasada ${diff} día${diff!==1?'s':''}`, color: "var(--mod-funcional)" };
      if (diff >= -3) return { ...a, monto, tipo: "proxima",  label: `🟡 Vence en ${-diff} día${-diff!==1?'s':''}`, color: "var(--fg-muted)" };
      return null;
    })
    .filter(Boolean);

  return (
    <React.Fragment>
      <div className="tp-ptitle">Inicio</div>

      {recordatorios.length > 0 && (
        <TPCard accent="funcional" style={{borderLeft:"3px solid var(--mod-funcional)", marginBottom:"1.25rem"}}>
          <div style={{display:"flex",alignItems:"center",justifyContent:"space-between",marginBottom:".5rem"}}>
            <div className="tp-ctitle" style={{margin:0, color:"var(--mod-funcional)"}}>
              ⏰ Recordatorios — {recordatorios.length} alumna{recordatorios.length!==1?'s':''}
            </div>
            <button className="tp-btn tp-btn-small">📲 Recordar a todas</button>
          </div>
          {recordatorios.map(r => (
            <div className="tp-rem-row" key={r.id}>
              <div className="tp-avatar" style={{width:30, height:30, fontSize:11}}>
                {window.TP_alumnaInits(r.nombre, r.apellido)}
              </div>
              <div style={{flex:1}}>
                <div style={{font:"500 13px var(--font-sans)"}}>{r.nombre} {r.apellido}</div>
                <div style={{font:"11px var(--font-sans)",color:r.color}}>{r.label}</div>
              </div>
              {r.monto > 0 && (
                <div style={{font:"600 12px var(--font-sans)"}}>{window.TP_money(r.monto)}</div>
              )}
              <a className="tp-wa-btn" href={"https://wa.me/" + r.tel} target="_blank">💬 WA</a>
            </div>
          ))}
        </TPCard>
      )}

      <div style={{display:"grid", gridTemplateColumns:"repeat(4,1fr)", gap:10, marginBottom:"1.25rem"}}>
        <TPMetric label="Alumnas activas" value={activas.length} tone="violet" />
        <TPMetric label={`Pagaron ${window.TP_mesLabel(mes)}`} value={pagaron} tone="violet" />
        <TPMetric label="Pendientes" value={pendientes} tone="warning" />
        <TPMetric label={`Recaudado ${window.TP_mesLabel(mes)}`} value={window.TP_money(recaudado)} />
      </div>

      <div style={{display:"grid", gridTemplateColumns:"1fr 1fr", gap:"1rem", marginBottom:"1rem"}}>
        <TPCard title="Alumnas por modalidad">
          <div style={{display:"flex", flexDirection:"column", gap:8}}>
            <div style={{display:"flex",alignItems:"center",justifyContent:"space-between"}}>
              <TPBadge modalidad="reformer" /><strong>{modCount.reformer.size}</strong>
            </div>
            <div style={{display:"flex",alignItems:"center",justifyContent:"space-between"}}>
              <TPBadge modalidad="mat" /><strong>{modCount.mat.size}</strong>
            </div>
            <div style={{display:"flex",alignItems:"center",justifyContent:"space-between"}}>
              <TPBadge modalidad="funcional" /><strong>{modCount.funcional.size}</strong>
            </div>
          </div>
        </TPCard>
        <TPCard title="Últimas clases">
          {db.clases.length ? db.clases.map(c => {
            const h = db.horarios.find(x => x.id === c.horario_id);
            return (
              <div key={c.id} style={{display:"flex",alignItems:"center",gap:8,padding:"5px 0",borderBottom:"1px solid var(--border)"}}>
                <div style={{flex:1, font:"13px var(--font-sans)"}}>
                  {c.fecha} {h && <TPBadge modalidad={h.modalidad} />}
                </div>
                <div style={{font:"11px var(--font-sans)", color:"var(--fg-muted)"}}>{c.ejercicios.length} ejs.</div>
              </div>
            );
          }) : <div style={{font:"13px var(--font-sans)", color:"var(--fg-muted)"}}>Sin clases registradas aún.</div>}
        </TPCard>
      </div>

      <TPCard accent="violet" style={{borderLeft:"3px solid var(--brand-violet)"}}>
        <div className="tp-ctitle" style={{marginBottom:".6rem"}}>📊 Semana en curso</div>
        <div style={{display:"grid", gridTemplateColumns:"repeat(2,1fr)", gap:8}}>
          <div style={{font:"13px var(--font-sans)"}}>
            <span style={{fontWeight:700, color:"var(--brand-violet)"}}>{db.clases.length}</span>
            <span style={{color:"var(--fg-muted)"}}> clase planificada</span>
          </div>
          <div style={{font:"13px var(--font-sans)"}}>
            <span style={{fontWeight:700, color:"var(--mod-funcional)"}}>{db.horarios.length - db.clases.length}</span>
            <span style={{color:"var(--fg-muted)"}}> pendientes de planificar</span>
          </div>
          <div style={{font:"13px var(--font-sans)"}}>
            <span style={{fontWeight:700, color:"var(--status-success)"}}>{window.TP_money(recaudado)}</span>
            <span style={{color:"var(--fg-muted)"}}> cobrado este mes</span>
          </div>
          <div style={{font:"13px var(--font-sans)"}}>
            <span style={{fontWeight:700, color:"var(--brand-violet)"}}>{pagaron}</span>
            <span style={{color:"var(--fg-muted)"}}> alumnas pagaron este mes</span>
          </div>
        </div>
      </TPCard>
    </React.Fragment>
  );
};

// ── Alumnas ─────────────────────────────────────────────────
const TPAlumnas = ({ db, onEdit, onOpenFicha, onNueva }) => {
  const activas  = db.alumnas.filter(a => a.estado === "activa");
  const pausadas = db.alumnas.filter(a => a.estado === "pausada");
  const mes = db.mesActual;
  const diaHoy = new Date().getDate();

  const rowFor = (a) => {
    const inscs = window.TP_inscByAlumna(db, a.id);
    const pagoMes = db.pagos.filter(p => p.alumna_id === a.id && p.mes === mes);
    const todoPagado = inscs.length > 0 && pagoMes.some(p => p.pagado);
    const vencio = !a.dia_pago || a.dia_pago <= diaHoy;
    const pagoStatus = todoPagado
      ? { kind: "ok",       label: "✓ Pagó" }
      : vencio
        ? { kind: "late",    label: "Pendiente de pago" }
        : { kind: "upcoming",label: "Vence día " + a.dia_pago };
    return <TPAlumnaRow key={a.id} alumna={a} inscs={inscs} pagoStatus={pagoStatus} onEdit={onEdit} onOpen={onOpenFicha} />;
  };

  return (
    <React.Fragment>
      <div style={{display:"flex", alignItems:"center", justifyContent:"space-between", marginBottom:"1.25rem"}}>
        <div className="tp-ptitle" style={{margin:0}}>Alumnas ({activas.length})</div>
        <button className="tp-btn tp-btn-primary" onClick={onNueva}>+ Nueva alumna</button>
      </div>
      <TPCard title="Activas">
        {activas.map(rowFor)}
      </TPCard>
      {pausadas.length > 0 && (
        <TPCard title="⏸ Pausadas">
          {pausadas.map(rowFor)}
        </TPCard>
      )}
    </React.Fragment>
  );
};

// ── Horarios ────────────────────────────────────────────────
const TPHorarios = ({ db, onSlotClick }) => {
  const dias = ["lun", "mar", "mie", "jue", "vie"];
  const capColor = (n, cap) => {
    if (!cap) return "var(--fg-muted)";
    const p = n / cap;
    return p >= 1 ? "var(--status-danger)" : p >= 0.8 ? "var(--mod-funcional)" : "var(--mod-mat)";
  };
  const capText = (n, cap) => {
    if (!cap) return n + " alumna";
    const left = cap - n;
    if (left <= 0) return n + "/" + cap + " · COMPLETO";
    return n + "/" + cap + " · " + left + " libre" + (left!==1?'s':'');
  };

  return (
    <React.Fragment>
      <div className="tp-ptitle">Horarios</div>
      <TPCard>
        <div className="tp-hgrid">
          {dias.map(dia => {
            const slots = db.horarios.filter(h => h.dia === dia)
              .sort((a,b) => a.hora_inicio.localeCompare(b.hora_inicio));
            return (
              <div className="tp-hcol" key={dia}>
                <div className="tp-hday">{window.TP_DIA_LABEL[dia]}</div>
                {slots.map(s => {
                  const n = db.inscripciones.filter(i => i.horario_id === s.id).length;
                  return (
                    <div key={s.id} className={"tp-hslot " + s.modalidad} onClick={() => onSlotClick && onSlotClick(s)}>
                      <div className="tp-hslot-time">{s.hora_inicio}–{s.hora_fin}</div>
                      <div className={"tp-hslot-mod " + s.modalidad}>{window.TP_MOD_LABEL[s.modalidad]}</div>
                      <div className="tp-hslot-n" style={{color: capColor(n, s.capacidad)}}>{capText(n, s.capacidad)}</div>
                    </div>
                  );
                })}
              </div>
            );
          })}
        </div>
      </TPCard>
    </React.Fragment>
  );
};

// ── Pagos ───────────────────────────────────────────────────
const TPPagos = ({ db, onMarkPagado, onNuevoPago }) => {
  const mes = db.mesActual;
  const activas = db.alumnas.filter(a => a.estado === "activa");

  return (
    <React.Fragment>
      <div style={{display:"flex", alignItems:"center", justifyContent:"space-between", marginBottom:"1.25rem"}}>
        <div className="tp-ptitle" style={{margin:0}}>Pagos</div>
        <button className="tp-btn tp-btn-primary" onClick={onNuevoPago}>+ Registrar pago</button>
      </div>
      <TPCard title={"Pagos · " + window.TP_mesLabel(mes)}>
        {activas.map(a => {
          const inscs = window.TP_inscByAlumna(db, a.id);
          const monto = inscs.reduce((s, i) => s + (i.precio || 0), 0);
          const pagado = db.pagos.find(p => p.alumna_id === a.id && p.mes === mes && p.pagado);
          return (
            <div key={a.id} style={{display:"flex",alignItems:"center",gap:10,padding:"8px 0",borderBottom:"1px solid var(--border)"}}>
              <div className="tp-avatar" style={{width:30,height:30,fontSize:11}}>
                {window.TP_alumnaInits(a.nombre, a.apellido)}
              </div>
              <div style={{flex:1, font:"13px var(--font-sans)"}}>{a.nombre} {a.apellido}</div>
              <div style={{font:"13px var(--font-sans)", color:"var(--fg-muted)", minWidth:90, textAlign:"right"}}>
                {window.TP_money(monto)}
              </div>
              {pagado ? (
                <span className="tp-pago-pill ok">✓ Pagado · {pagado.fecha}</span>
              ) : (
                <button className="tp-btn tp-btn-small tp-btn-primary" onClick={() => onMarkPagado(a.id)}>Marcar pagado</button>
              )}
            </div>
          );
        })}
      </TPCard>
    </React.Fragment>
  );
};

// ── Modal: Nueva alumna ─────────────────────────────────────
const TPModalAlumna = ({ onCancel, onSave }) => {
  const [form, setForm] = useState({
    nombre: "", apellido: "", tel: "", email: "",
    notas: "", contra: "", dia_pago: "", nacimiento: "",
  });
  const set = (k) => (e) => setForm({ ...form, [k]: e.target.value });
  return (
    <div className="tp-modal-bg" onClick={(e) => e.target===e.currentTarget && onCancel()}>
      <div className="tp-modal" onClick={(e) => e.stopPropagation()}>
        <h3>Nueva alumna</h3>
        <div className="tp-frow">
          <div><label>Nombre *</label><input value={form.nombre} onChange={set("nombre")} placeholder="Ej: María" /></div>
          <div><label>Apellido</label><input value={form.apellido} onChange={set("apellido")} placeholder="Ej: González" /></div>
        </div>
        <div className="tp-frow">
          <div><label>Teléfono (WhatsApp)</label><input value={form.tel} onChange={set("tel")} placeholder="5491112345678" /></div>
          <div><label>Email</label><input value={form.email} onChange={set("email")} placeholder="maria@gmail.com" /></div>
        </div>
        <label>Notas</label>
        <textarea value={form.notas} onChange={set("notas")} placeholder="Preferencias, observaciones generales..." />
        <label style={{color:"var(--status-danger)", fontWeight:600}}>🏥 Contraindicaciones / Lesiones</label>
        <textarea value={form.contra} onChange={set("contra")} placeholder="Ej: Rodilla derecha — sin flexión profunda · Hernia lumbar L4-L5" style={{height:52, borderColor:"var(--status-danger)"}} />
        <div className="tp-frow" style={{marginTop:4}}>
          <div><label>Día de pago (1–31)</label><input type="number" min="1" max="31" value={form.dia_pago} onChange={set("dia_pago")} placeholder="Ej: 10" /></div>
          <div><label>Fecha de nacimiento</label><input type="date" value={form.nacimiento} onChange={set("nacimiento")} /></div>
        </div>
        <div style={{display:"flex", gap:8, justifyContent:"flex-end", marginTop:".75rem"}}>
          <button className="tp-btn" onClick={onCancel}>Cancelar</button>
          <button className="tp-btn tp-btn-primary" onClick={() => onSave(form)}>Guardar</button>
        </div>
      </div>
    </div>
  );
};

Object.assign(window, { TPLogin, TPInicio, TPAlumnas, TPHorarios, TPPagos, TPModalAlumna });
