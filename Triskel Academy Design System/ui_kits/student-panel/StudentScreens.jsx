// Screens.jsx — student panel screens
const { useState } = React;

// ── Auth ────────────────────────────────────────────────────
const SPAuthScreen = ({ onLogin }) => {
  const [email, setEmail] = useState("maria.gonzalez@gmail.com");
  const [pwd, setPwd] = useState("••••••••");
  const [err, setErr] = useState("");
  const submit = () => {
    if (!email || !pwd) { setErr("Completá email y contraseña."); return; }
    setErr("");
    onLogin();
  };
  return (
    <div className="sp-auth">
      <img src="../../assets/logo-triskel.png" className="sp-auth-logo" alt="Triskel" />
      <div className="sp-auth-title">Triskel Academy</div>
      <div className="sp-auth-sub">Mi Panel de Alumna</div>
      <div className="sp-auth-card">
        <label>Email</label>
        <input className="sp-input" type="email" autoComplete="email"
               value={email} onChange={(e)=>setEmail(e.target.value)} />
        <label>Contraseña</label>
        <input className="sp-input" type="password" autoComplete="current-password"
               value={pwd} onChange={(e)=>setPwd(e.target.value)}
               onKeyDown={(e)=> e.key==='Enter' && submit()} />
        <button className="sp-btn-primary" onClick={submit}>Ingresar</button>
        <div className="sp-auth-error">{err}</div>
      </div>
    </div>
  );
};

// ── Inicio ──────────────────────────────────────────────────
const SPInicio = ({ state, onAvisar, onEnableNotif }) => {
  const mes = window.SP_mesActual();
  const cobrado = state.pagos.find(p => p.mes === mes && p.pagado);
  const aviso   = state.avisos.find(av => av.mes === mes && av.estado === "pendiente");
  const inscs   = state.inscripciones || [];

  // Today's class
  const today = new Date().getDay();
  const dayMap = {1:"lun", 2:"mar", 3:"mie", 4:"jue", 5:"vie"};
  const todayKey = dayMap[today];
  const hoy = inscs.filter(i => i.dia === todayKey);

  let pagoCard;
  if (cobrado) {
    pagoCard = (
      <SPCard accent="mat">
        <div style={{display:"flex",alignItems:"center",gap:"0.5rem"}}>
          <div style={{fontSize:"28px"}}>✅</div>
          <div>
            <div style={{font:"var(--type-caption)"}}>Cuota {window.SP_mesLabel(mes)}</div>
            <div className="sp-pago-estado cobrado">¡Pagada!</div>
            {cobrado.monto && <div style={{font:"var(--type-caption)"}}>{window.SP_money(cobrado.monto)}</div>}
            {cobrado.nota && <div style={{font:"11px var(--font-sans)",color:"var(--fg-muted)",fontStyle:"italic",marginTop:"0.1rem"}}>"{cobrado.nota}"</div>}
          </div>
        </div>
      </SPCard>
    );
  } else if (aviso) {
    pagoCard = (
      <SPCard accent="warning">
        <div style={{display:"flex",alignItems:"center",gap:"0.5rem"}}>
          <div style={{fontSize:"28px"}}>⏳</div>
          <div>
            <div style={{font:"var(--type-caption)"}}>Cuota {window.SP_mesLabel(mes)}</div>
            <div className="sp-pago-estado pendiente" style={{fontSize:"15px"}}>Pendiente de aprobación</div>
            <div style={{font:"12px var(--font-sans)",color:"var(--fg-muted)"}}>Avisaste que pagaste · Amira está revisando</div>
          </div>
        </div>
      </SPCard>
    );
  } else {
    pagoCard = (
      <SPCard accent="danger">
        <div style={{font:"var(--type-caption)",marginBottom:"0.4rem"}}>Cuota {window.SP_mesLabel(mes)}</div>
        <div className="sp-pago-estado sin" style={{fontSize:"15px",marginBottom:"0.75rem"}}>⚠️ Sin pago registrado</div>
        <button className="sp-btn-pague" onClick={() => onAvisar(mes)}>💳 Avisar que pagué</button>
      </SPCard>
    );
  }

  return (
    <React.Fragment>
      <SPNotifBanner onEnable={onEnableNotif} />
      {pagoCard}
      {hoy.length > 0 && (
        <SPCard>
          <SPCardTitle icon="📍">Clase de hoy</SPCardTitle>
          {hoy.map(i => (
            <SPScheduleItem
              key={i.id}
              modalidad={i.modalidad}
              title={`${window.SP_MOD_LABEL[i.modalidad]}${i.plan_nombre?' · '+i.plan_nombre:''}`}
              sub={i.horario}
            />
          ))}
        </SPCard>
      )}
      <SPCard>
        <SPCardTitle icon="📋">Mi inscripción</SPCardTitle>
        {inscs.length ? inscs.map(i => (
          <SPScheduleItem
            key={i.id}
            modalidad={i.modalidad}
            title={`${window.SP_MOD_LABEL[i.modalidad]}${i.plan_nombre ? ' · '+i.plan_nombre : ''}`}
            sub={`${window.SP_DIA_LABEL[i.dia]||i.dia}${i.horario?' · '+i.horario:''}`}
          />
        )) : <div style={{font:"13px var(--font-sans)",color:"var(--fg-muted)"}}>Sin inscripciones activas.</div>}
      </SPCard>
    </React.Fragment>
  );
};

// ── Horarios ────────────────────────────────────────────────
const SPHorarios = ({ state }) => {
  const inscs = state.inscripciones || [];
  if (!inscs.length) {
    return (
      <SPCard style={{textAlign:"center",padding:"2rem"}}>
        <div style={{fontSize:"32px",marginBottom:"0.5rem"}}>📅</div>
        <div style={{font:"14px var(--font-sans)",color:"var(--fg-muted)"}}>
          No tenés inscripciones activas.<br/>Hablá con Amira para inscribirte.
        </div>
      </SPCard>
    );
  }
  const grouped = {};
  inscs.forEach(i => { (grouped[i.dia] ||= []).push(i); });
  const days = Object.keys(grouped).sort((a,b) => window.SP_DIA_ORDER[a] - window.SP_DIA_ORDER[b]);
  return (
    <React.Fragment>
      {days.map(d => (
        <SPCard key={d}>
          <SPCardTitle icon="📅">{window.SP_DIA_LABEL[d]||d}</SPCardTitle>
          {grouped[d].map(i => (
            <SPScheduleItem
              key={i.id}
              modalidad={i.modalidad}
              title={window.SP_MOD_LABEL[i.modalidad]}
              plan={i.plan_nombre}
              sub={i.horario ? `🕐 ${i.horario}` : null}
            />
          ))}
        </SPCard>
      ))}
    </React.Fragment>
  );
};

// ── Pagos ───────────────────────────────────────────────────
const SPPagos = ({ state, onAvisar }) => {
  const mes = window.SP_mesActual();
  const cobrado = state.pagos.find(p => p.mes === mes && p.pagado);
  const aviso   = state.avisos.find(av => av.mes === mes && av.estado === "pendiente");

  return (
    <React.Fragment>
      <SPCard accent={cobrado ? "mat" : aviso ? "warning" : "danger"}>
        <div style={{font:"11px var(--font-sans)",fontWeight:700,color:"var(--fg-muted)",textTransform:"uppercase",letterSpacing:".05em"}}>
          Cuota {window.SP_mesLabel(mes)}
        </div>
        <div className={`sp-pago-estado ${cobrado?'cobrado':aviso?'pendiente':'sin'}`}>
          {cobrado ? "✅ ¡Pagada!" : aviso ? "⏳ Pendiente de aprobación" : "⚠️ Sin pago registrado"}
        </div>
        {!cobrado && !aviso && (
          <button className="sp-btn-pague" onClick={() => onAvisar(mes)} style={{marginTop:".5rem"}}>
            💳 Avisar que pagué
          </button>
        )}
        {aviso && (
          <div style={{font:"12px var(--font-sans)",color:"var(--fg-muted)",marginTop:".4rem"}}>
            Amira lo está revisando.
          </div>
        )}
      </SPCard>
      <SPCard>
        <SPCardTitle icon="📚">Historial</SPCardTitle>
        {state.pagos.map(p => (
          <div className="sp-hist-row" key={p.mes}>
            <span className="sp-hist-mes">{window.SP_mesLabel(p.mes)}</span>
            <span className="sp-hist-monto">{window.SP_money(p.monto)}</span>
          </div>
        ))}
      </SPCard>
    </React.Fragment>
  );
};

// ── Perfil ──────────────────────────────────────────────────
const SPPerfil = ({ state, onPhoto, onLogout }) => {
  const a = state.alumna;
  return (
    <React.Fragment>
      <SPCard>
        <div className="sp-profile-photo-wrap">
          <div className="sp-profile-photo">{a.foto ? <img src={a.foto} alt=""/> : "👤"}</div>
          <button onClick={onPhoto} style={{marginTop:".5rem",font:"12px var(--font-sans)",color:"var(--brand-violet)",background:"none",border:"1px solid var(--brand-violet)",borderRadius:"20px",padding:".2rem .75rem",cursor:"pointer"}}>
            Cambiar foto
          </button>
          <div className="sp-profile-name">{a.nombre}</div>
          <div className="sp-profile-email">{a.email}</div>
        </div>
        <div className="sp-profile-row">
          <span className="sp-profile-label">Teléfono</span>
          <span className="sp-profile-val">{a.tel || "—"}</span>
        </div>
        <div className="sp-profile-row">
          <span className="sp-profile-label">Día de pago</span>
          <span className="sp-profile-val">Día {a.dia_pago || "—"} del mes</span>
        </div>
        <div className="sp-profile-row">
          <span className="sp-profile-label">Modalidades</span>
          <span style={{display:"flex",gap:"4px",flexWrap:"wrap"}}>
            {[...new Set(state.inscripciones.map(i => i.modalidad))].map(m => (
              <SPChip key={m} modalidad={m} />
            ))}
          </span>
        </div>
      </SPCard>
      <SPCard>
        <SPCardTitle icon="⚙️">Cuenta</SPCardTitle>
        <button className="sp-btn-pague" style={{background:"#fff",color:"var(--brand-violet)",border:"1.5px solid var(--brand-violet)"}} onClick={onLogout}>
          🚪 Cerrar sesión
        </button>
      </SPCard>
    </React.Fragment>
  );
};

// ── Modal Aviso Pago ────────────────────────────────────────
const SPModalAvisoPago = ({ mes, defaultMonto, onCancel, onConfirm }) => {
  const [monto, setMonto] = useState(defaultMonto || 25000);
  const [nota, setNota] = useState("");
  return (
    <div className="sp-modal-overlay" onClick={(e)=>e.target===e.currentTarget && onCancel()}>
      <div className="sp-modal-sheet" onClick={(e)=>e.stopPropagation()}>
        <div className="sp-modal-handle" />
        <div className="sp-modal-title">💳 Avisar pago</div>
        <div style={{font:"13px var(--font-sans)",color:"var(--fg-muted)",marginBottom:".5rem"}}>
          Completá los datos de tu pago y Amira lo confirmará.
        </div>
        <div style={{font:"13px var(--font-sans)",fontWeight:600,color:"var(--brand-violet)",marginBottom:".5rem"}}>
          {window.SP_mesLabel(mes)}
        </div>
        <label className="sp-modal-label">
          Monto abonado <span style={{fontWeight:400,color:"#aaa"}}>(podés modificarlo)</span>
        </label>
        <input className="sp-input" type="number" value={monto}
               onChange={(e)=>setMonto(Number(e.target.value))} />
        <label className="sp-modal-label">Nota (opcional)</label>
        <input className="sp-input" type="text" value={nota}
               placeholder="Ej: Transferí al CBU, operación 123456"
               onChange={(e)=>setNota(e.target.value)} maxLength={200} />
        <div className="sp-modal-row">
          <button className="sp-btn-cancel" onClick={onCancel}>Cancelar</button>
          <button className="sp-btn-confirm" onClick={()=>onConfirm({mes, monto, nota})}>Avisar pago ✓</button>
        </div>
      </div>
    </div>
  );
};

Object.assign(window, {
  SPAuthScreen, SPInicio, SPHorarios, SPPagos, SPPerfil, SPModalAvisoPago,
});
