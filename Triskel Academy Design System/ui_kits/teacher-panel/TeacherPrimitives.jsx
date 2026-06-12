// Primitives.jsx — teacher panel building blocks.

const TPBadge = ({ modalidad, children }) => (
  <span className={`tp-badge tp-badge-${modalidad}`}>{children || window.TP_MOD_LABEL[modalidad] || modalidad}</span>
);

const TPCard = ({ children, title, accent, style }) => {
  const cls = "tp-card" + (accent ? ` tp-card-accent-${accent}` : "");
  return (
    <div className={cls} style={style}>
      {title ? <div className="tp-ctitle">{title}</div> : null}
      {children}
    </div>
  );
};

const TPMetric = ({ label, value, tone }) => (
  <div className="tp-metric">
    <div className="tp-metric-label">{label}</div>
    <div className={"tp-metric-value" + (tone ? " " + tone : "")}>{value}</div>
  </div>
);

const TPSidebar = ({ current, onNav, onSearch, onOpenTarifas, onOpenMensajes, onToggleTheme, onLogout, badgePagos }) => {
  const items = [
    { sep: "Principal" },
    { id: "inicio",     ico: "🏠", lbl: "Inicio" },
    { id: "alumnas",    ico: "👤", lbl: "Alumnas" },
    { sep: "Clases" },
    { id: "horarios",   ico: "📅", lbl: "Horarios" },
    { id: "clases",     ico: "📝", lbl: "Planificar" },
    { id: "historial",  ico: "📚", lbl: "Historial" },
    { sep: "Gestión" },
    { id: "pagos",      ico: "💰", lbl: "Pagos", badge: badgePagos },
    { id: "tarifas",    ico: "⚙",  lbl: "Tarifas", action: onOpenTarifas },
    { id: "mensajes",   ico: "💬", lbl: "Mensajes WA", action: onOpenMensajes },
  ];
  return (
    <aside className="tp-sidebar">
      <div className="tp-sidebar-logo">
        <div className="tp-sidebar-logo-name">
          <img src="../../assets/logo-triskel.png" alt="" />
          Triskel Academy
        </div>
        <div className="tp-sidebar-logo-sub">Panel de gestión</div>
      </div>
      <div className="tp-sidebar-search">
        <input placeholder="🔍 Buscar alumna..." onChange={(e) => onSearch && onSearch(e.target.value)} />
      </div>
      <nav className="tp-snav">
        {items.map((it, idx) => it.sep ? (
          <div key={"sep" + idx} className="sep">{it.sep}</div>
        ) : (
          <a key={it.id}
             className={current === it.id ? "active" : ""}
             onClick={(e) => { e.preventDefault(); it.action ? it.action() : onNav(it.id); }}
             href="#">
            <span>{it.ico}</span>
            <span style={{flex:1}}>{it.lbl}</span>
            {it.badge ? <span style={{background:"var(--status-danger)",color:"#fff",font:"700 10px var(--font-sans)",borderRadius:"99px",padding:"1px 6px"}}>{it.badge}</span> : null}
          </a>
        ))}
      </nav>
      <div className="tp-sbottom">
        <button onClick={onToggleTheme}>🌙 Modo oscuro</button>
        <button onClick={onLogout} style={{marginTop:2}}>↩ Salir</button>
      </div>
    </aside>
  );
};

const TPAlumnaRow = ({ alumna, inscs, pagoStatus, onEdit, onOpen }) => (
  <div className="tp-arow">
    <div className="tp-avatar">{window.TP_alumnaInits(alumna.nombre, alumna.apellido)}</div>
    <div style={{flex:1, minWidth:0}}>
      <div className="tp-aname tp-aname-link" onClick={() => onOpen(alumna.id)}>
        {alumna.nombre} {alumna.apellido || ""}
      </div>
      <div className="tp-asub">
        {inscs.map((i, idx) => i.horario ? (
          <span key={idx} style={{display:"inline-flex",alignItems:"center",gap:3}}>
            <TPBadge modalidad={i.horario.modalidad} />
            <span style={{font:"10px var(--font-sans)",color:"var(--fg-muted)"}}>
              {window.TP_DIA_LABEL[i.horario.dia]} {i.horario.hora_inicio}
            </span>
          </span>
        ) : null)}
        {alumna.tel && <a href={"https://wa.me/" + alumna.tel} target="_blank" style={{font:"11px var(--font-sans)",color:"var(--mod-mat)",textDecoration:"none"}}>💬 WA</a>}
      </div>
    </div>
    {inscs.length > 0 && pagoStatus && (
      <span className={"tp-pago-pill " + pagoStatus.kind}>{pagoStatus.label}</span>
    )}
    <div style={{display:"flex",gap:6,flexWrap:"wrap"}}>
      <button className="tp-btn tp-btn-small" onClick={() => onEdit(alumna.id)}>Editar</button>
      {alumna.estado === "activa" && <button className="tp-btn tp-btn-small">⏸ Pausar</button>}
      {alumna.estado === "pausada" && <button className="tp-btn tp-btn-small tp-btn-primary">▶ Reactivar</button>}
    </div>
  </div>
);

Object.assign(window, { TPBadge, TPCard, TPMetric, TPSidebar, TPAlumnaRow });
