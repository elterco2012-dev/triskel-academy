// Primitives.jsx — reusable building blocks for the student panel
// Loaded as a global Babel script. Exports onto window.

const SPCard = ({ children, accent, style }) => {
  const cls = "sp-card" + (accent ? ` sp-card-accent-${accent}` : "");
  return <div className={cls} style={style}>{children}</div>;
};

const SPCardTitle = ({ children, icon }) => (
  <div className="sp-card-title">
    {icon ? <span>{icon}</span> : null}
    <span>{children}</span>
  </div>
);

const SPChip = ({ modalidad, children }) => (
  <span className={`sp-chip ${window.SP_MOD_CHIP[modalidad] || ""}`}>
    {children || window.SP_MOD_LABEL[modalidad] || modalidad}
  </span>
);

const SPScheduleItem = ({ modalidad, title, sub, plan }) => (
  <div className="sp-sched-item">
    <div className="sp-sched-dot" style={{ background: window.SP_MOD_COLOR[modalidad] || "#666" }} />
    <div className="sp-sched-info">
      <div className="sp-sched-mod">
        <span>{title}</span>
        {plan ? <SPChip modalidad={modalidad}>{plan}</SPChip> : null}
      </div>
      {sub ? <div className="sp-sched-dia">{sub}</div> : null}
    </div>
  </div>
);

const SPHeader = ({ nombre, onLogout }) => (
  <div className="sp-header">
    <div className="sp-header-logo">
      <img src="../../assets/logo-triskel.png" alt="Triskel" />
    </div>
    <div>
      <div className="sp-header-title">{nombre || "Mi cuenta"}</div>
      <div className="sp-header-sub">Triskel Academy</div>
    </div>
    <div className="sp-header-right">
      <button className="sp-icon-btn" onClick={onLogout} title="Salir">🚪</button>
    </div>
  </div>
);

const SPBottomNav = ({ current, onNav, pagoStatus }) => {
  const pagoIcon = pagoStatus === "aviso" ? "🔔" : pagoStatus === "sin" ? "⚠️" : "💳";
  const items = [
    { id: "inicio",   ico: "🏠", lbl: "Inicio" },
    { id: "horarios", ico: "📅", lbl: "Horarios" },
    { id: "pagos",    ico: pagoIcon, lbl: "Pagos" },
    { id: "perfil",   ico: "👤", lbl: "Perfil" },
  ];
  return (
    <nav className="sp-bnav">
      {items.map((it) => (
        <button
          key={it.id}
          className={"sp-nav-item" + (current === it.id ? " active" : "")}
          onClick={() => onNav(it.id)}
        >
          <span className="sp-nav-icon">{it.ico}</span>
          {it.lbl}
        </button>
      ))}
    </nav>
  );
};

const SPNotifBanner = ({ onEnable }) => (
  <div className="sp-notif-banner">
    <span className="ico">🔔</span>
    <div style={{ flex: 1 }}>
      <strong>Activá notificaciones</strong>
      <span>Te avisamos cuando se acerque tu cuota.</span>
    </div>
    <button className="sp-btn-notif" onClick={onEnable}>Activar</button>
  </div>
);

const SPToast = ({ text }) => text ? <div className="sp-toast">{text}</div> : null;

const SPLoading = () => (
  <div className="sp-loading">
    <div className="sp-spinner" />
    Cargando...
  </div>
);

Object.assign(window, {
  SPCard, SPCardTitle, SPChip, SPScheduleItem,
  SPHeader, SPBottomNav, SPNotifBanner, SPToast, SPLoading,
});
