// InicioPropuesta.jsx — improved Inicio applying fixes #1-#4.
// #1 chromatic discipline (neutral headers, white cards + left accent)
// #2 "requiere atención" = white card, label once, violet avatars, actionable rows, top-N
// #3 violet secondary CTA (not full-width saturated blue)
// #4 Esfero in safe teal — red reserved for negative state only

const ATENCION_P = [
  { n:"Adriana Iraola",     d:"5 ausencias seguidas · última clase 26 may" },
  { n:"Florencia Silva",    d:"4 ausencias seguidas · última clase 28 may" },
  { n:"Gabriela Perez",     d:"3 ausencias seguidas · última clase 30 may" },
  { n:"Isabel Da Luz Fernandez", d:"3 ausencias seguidas · última clase 30 may" },
];
const RECORD_P = [
  { n:"Maria Cristina Garegnani", e:"Vence hoy", urgent:true,  m:"$37.000" },
  { n:"Mirta Amarilla",           e:"Vence hoy", urgent:true,  m:"$33.000" },
  { n:"Analia Marcela Menakian",  e:"Atrasada 6 días", urgent:false, m:"" },
  { n:"Julieta Cornador",         e:"Atrasada 7 días", urgent:false, m:"$18.500" },
];

function inits(name){ const p=name.split(" "); return ((p[0]||"")[0]+((p[1]||"")[0]||"")).toUpperCase(); }

// Neutral, consistent section header — color carries meaning, not decoration.
function SectionHead({ children, count, action }) {
  return (
    <div style={{display:"flex", alignItems:"center", justifyContent:"space-between", marginBottom:".75rem"}}>
      <div style={{display:"flex", alignItems:"baseline", gap:8}}>
        <span style={{font:"600 11px var(--font-sans)", letterSpacing:".06em", textTransform:"uppercase", color:"var(--fg-muted)"}}>{children}</span>
        {count!=null && <span style={{font:"600 11px var(--font-sans)", color:"var(--fg-faint)"}}>{count}</span>}
      </div>
      {action}
    </div>
  );
}

function InicioPropuesta() {
  return (
    <div className="tp-root" style={{height:"100%"}}>
      <div className="tp-shell">
        <PropuestaSidebar />
        <main className="tp-main" style={{overflow:"hidden"}}>
          <div style={{display:"flex", alignItems:"flex-end", justifyContent:"space-between", marginBottom:"1.5rem"}}>
            <div className="tp-ptitle" style={{margin:0}}>Inicio</div>
            {/* #3 — secondary violet CTA, not a full-width blue bar */}
            <button className="tp-btn" style={{borderColor:"var(--brand-violet)", color:"var(--brand-violet)", fontWeight:500}}>Ver informe mensual →</button>
          </div>

          {/* Metrics FIRST — the at-a-glance numbers earn the top spot */}
          <div style={{display:"grid", gridTemplateColumns:"repeat(4,1fr)", gap:10, marginBottom:"1.5rem"}}>
            <div className="tp-metric"><div className="tp-metric-label">Alumnas activas</div><div className="tp-metric-value violet">54</div></div>
            <div className="tp-metric"><div className="tp-metric-label">Pagaron Jun 2026</div><div className="tp-metric-value violet">29</div></div>
            <div className="tp-metric"><div className="tp-metric-label">Pendientes</div><div className="tp-metric-value warning">25</div></div>
            <div className="tp-metric"><div className="tp-metric-label">Recaudado Jun 2026</div><div className="tp-metric-value">$1.079.000</div></div>
          </div>

          {/* #2 — Requiere atención: WHITE card, red 3px accent, label ONCE, violet avatars, actionable rows, top-N */}
          <div className="tp-card" style={{borderLeft:"3px solid var(--status-danger)"}}>
            <SectionHead count="14" action={<a href="#" onClick={e=>e.preventDefault()} style={{font:"12px var(--font-sans)", color:"var(--brand-violet)", textDecoration:"none"}}>Ver las 14 →</a>}>
              Requiere atención
            </SectionHead>
            <div style={{font:"12px var(--font-sans)", color:"var(--fg-muted)", marginTop:"-.5rem", marginBottom:".75rem"}}>
              Riesgo de abandono · 3+ ausencias seguidas
            </div>
            {ATENCION_P.map((a,i)=>(
              <div key={i} style={{display:"flex", alignItems:"center", gap:10, padding:"8px 0", borderBottom: i<ATENCION_P.length-1?"1px solid var(--border)":"none"}}>
                <div className="tp-avatar" style={{width:32,height:32,fontSize:12}}>{inits(a.n)}</div>
                <div style={{flex:1, minWidth:0}}>
                  <div style={{font:"500 13px var(--font-sans)"}}>{a.n}</div>
                  <div style={{font:"11px var(--font-sans)", color:"var(--fg-muted)"}}>{a.d}</div>
                </div>
                <span style={{padding:"4px 10px",border:"1px solid var(--mod-mat)",borderRadius:"var(--radius)",background:"var(--mod-mat-tint)",color:"var(--mod-mat)",font:"500 11px var(--font-sans)",whiteSpace:"nowrap"}}>💬 WA</span>
              </div>
            ))}
          </div>

          {/* Recordatorios — WHITE card, amber 3px accent */}
          <div className="tp-card" style={{borderLeft:"3px solid var(--status-warning)"}}>
            <SectionHead count="7" action={<button className="tp-btn tp-btn-small">Recordar a todas</button>}>
              Recordatorios de pago
            </SectionHead>
            {RECORD_P.map((r,i)=>(
              <div key={i} style={{display:"flex", alignItems:"center", gap:10, padding:"8px 0", borderBottom: i<RECORD_P.length-1?"1px solid var(--border)":"none"}}>
                <div className="tp-avatar" style={{width:32,height:32,fontSize:12}}>{inits(r.n)}</div>
                <div style={{flex:1, minWidth:0}}>
                  <div style={{font:"500 13px var(--font-sans)"}}>{r.n}</div>
                  <div style={{font:"11px var(--font-sans)", color: r.urgent ? "var(--status-danger)" : "var(--fg-muted)"}}>
                    {r.urgent && <span style={{display:"inline-block",width:7,height:7,borderRadius:"50%",background:"var(--status-danger)",marginRight:5,verticalAlign:"middle"}} />}
                    {r.e}
                  </div>
                </div>
                {r.m && <div style={{font:"600 12px var(--font-sans)"}}>{r.m}</div>}
                <span style={{padding:"4px 10px",border:"1px solid var(--mod-mat)",borderRadius:"var(--radius)",background:"var(--mod-mat-tint)",color:"var(--mod-mat)",font:"500 11px var(--font-sans)",whiteSpace:"nowrap"}}>💬 WA</span>
              </div>
            ))}
          </div>

          {/* Two neutral cards: cumpleaños + modalidad (with #4 Esfero in safe teal) */}
          <div style={{display:"grid", gridTemplateColumns:"1fr 1fr", gap:"1rem", marginBottom:"1rem"}}>
            <div className="tp-card" style={{marginBottom:0}}>
              <SectionHead>Próximos cumpleaños</SectionHead>
              <div style={{display:"flex", alignItems:"center", gap:10}}>
                <div className="tp-avatar" style={{width:30,height:30,fontSize:11}}>MA</div>
                <div style={{flex:1, font:"13px var(--font-sans)"}}>Micaela Aguilar</div>
                <div style={{font:"12px var(--font-sans)", color:"var(--fg-muted)"}}>Domingo</div>
                <button className="tp-btn tp-btn-small">Saludar</button>
              </div>
            </div>
            <div className="tp-card" style={{marginBottom:0}}>
              <SectionHead>Alumnas por modalidad</SectionHead>
              <div style={{display:"flex", flexDirection:"column", gap:8}}>
                <ModRow color="var(--mod-reformer)" bg="var(--mod-reformer-tint)" label="Reformer" n={28} />
                <ModRow color="var(--mod-mat)" bg="var(--mod-mat-tint)" label="Mat" n={14} />
                <ModRow color="var(--mod-funcional)" bg="var(--mod-funcional-tint)" label="Funcional" n={13} />
                {/* #4 — Esfero in SAFE TEAL, clearly distinct from danger red */}
                <ModRow color="#0D9488" bg="#CCFBF1" label="Esfero" n={6} />
              </div>
            </div>
          </div>

          {/* Notificaciones — quiet inline confirmation, not a full green card */}
          <div style={{display:"flex", alignItems:"center", gap:8, font:"12px var(--font-sans)", color:"var(--fg-muted)", padding:"4px 2px"}}>
            <span style={{color:"var(--mod-mat)"}}>✓</span>
            Notificaciones activas — vas a recibir avisos cuando una alumna reporte un pago.
          </div>
        </main>
      </div>
    </div>
  );
}

function ModRow({ color, bg, label, n }) {
  return (
    <div style={{display:"flex", alignItems:"center", justifyContent:"space-between"}}>
      <span className="tp-badge" style={{background:bg, color:color}}>{label}</span>
      <strong style={{font:"600 14px var(--font-sans)"}}>{n}</strong>
    </div>
  );
}

function PropuestaSidebar(){
  const items=[
    {sep:"Principal"},{ico:"🏠",l:"Inicio",active:true},{ico:"👤",l:"Alumnas"},
    {sep:"Clases"},{ico:"📅",l:"Horarios"},{ico:"📝",l:"Planificar"},{ico:"📚",l:"Historial"},{ico:"📋",l:"Planes"},
    {sep:"Gestión"},{ico:"💰",l:"Pagos"},{ico:"📗",l:"Biblioteca"},{ico:"⚙",l:"Tarifas"},{ico:"💬",l:"Mensajes WA"},
  ];
  return (
    <aside className="tp-sidebar">
      <div className="tp-sidebar-logo">
        <div className="tp-sidebar-logo-name"><img src="../../assets/logo-triskel.png" alt=""/>Triskel Academy</div>
        <div className="tp-sidebar-logo-sub">Panel de gestión</div>
      </div>
      <div className="tp-sidebar-search"><input placeholder="🔍 Buscar alumna..."/></div>
      <nav className="tp-snav">
        {items.map((it,i)=> it.sep
          ? <div key={i} className="sep">{it.sep}</div>
          : <a key={i} className={it.active?"active":""} href="#" onClick={e=>e.preventDefault()}><span>{it.ico}</span><span style={{flex:1}}>{it.l}</span></a>
        )}
      </nav>
      <div className="tp-sbottom">
        <button>🌙 Modo oscuro</button>
        <button style={{marginTop:2}}>↩ Salir</button>
      </div>
    </aside>
  );
}

Object.assign(window, { InicioPropuesta });
