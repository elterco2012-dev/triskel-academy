// InicioActual.jsx — faithful recreation of the CURRENT Inicio (from screenshots).
// Demonstrates the chromatic overload + red-wall problem. Read-only mock.

const ATENCION = [
  "Adriana Iraola","Florencia Silva","Gabriela Perez","Isabel Da Luz Fernandez",
  "Lucia Cesar","Luciana Perez","Magali Avril Pighetti Becker","Maria Cristina Garegnani",
  "Maria Julia Alberto","Mariana Goñi","Priscila Sanz","Uma Gomez",
];
const RECORD = [
  { n:"Maria Cristina Garegnani", e:"🔴 Vence HOY", c:"#dc2626", m:"$37.000" },
  { n:"Mirta Amarilla",           e:"🔴 Vence HOY", c:"#dc2626", m:"$33.000" },
  { n:"Analia Marcela Menakian",  e:"🟠 Atrasada 6 días", c:"#D97706", m:"" },
  { n:"Claudia Soriano",          e:"🟠 Atrasada 6 días", c:"#D97706", m:"" },
  { n:"Julieta Cornador",         e:"🟠 Atrasada 7 días", c:"#D97706", m:"$18.500" },
];

function initials(name){ const p=name.split(" "); return ((p[0]||"")[0]+((p[1]||"")[0]||"")).toUpperCase(); }

function InicioActual() {
  return (
    <div className="tp-root" style={{height:"100%"}}>
      <div className="tp-shell">
        <ActualSidebar />
        <main className="tp-main" style={{overflow:"hidden"}}>
          <div className="tp-ptitle">Inicio</div>

          {/* Cumpleaños — amber filled border + amber header */}
          <div className="tp-card" style={{border:"2px solid var(--mod-funcional)", borderRadius:"var(--radius-lg)"}}>
            <div style={{font:"600 11px var(--font-sans)", letterSpacing:".06em", textTransform:"uppercase", color:"var(--mod-funcional)", marginBottom:".6rem"}}>🎂 Próximos cumpleaños</div>
            <div style={{display:"flex", alignItems:"center", gap:10}}>
              <div className="tp-avatar" style={{width:30,height:30,fontSize:11}}>MA</div>
              <div style={{flex:1, font:"13px var(--font-sans)"}}>Micaela Aguilar</div>
              <div style={{font:"12px var(--font-sans)", color:"var(--mod-funcional)", fontWeight:600}}>Domingo</div>
              <button className="tp-btn tp-btn-small" style={{borderColor:"var(--mod-funcional)", color:"var(--mod-funcional)"}}>🎉 Saludar</button>
            </div>
          </div>

          {/* Requiere atención — FULL RED FILL + granate avatars + repeated label */}
          <div style={{background:"#FCEBEB", border:"2px solid var(--status-danger)", borderRadius:"var(--radius-lg)", padding:"1.25rem", marginBottom:"1rem"}}>
            <div style={{font:"600 11px var(--font-sans)", letterSpacing:".06em", textTransform:"uppercase", color:"var(--status-danger)", marginBottom:".2rem"}}>🔔 Requiere atención (14)</div>
            <div style={{font:"600 10px var(--font-sans)", letterSpacing:".05em", textTransform:"uppercase", color:"var(--fg-muted)", marginBottom:".5rem"}}>3+ ausencias seguidas</div>
            {ATENCION.map((n,i)=>(
              <div key={i} style={{display:"flex", alignItems:"center", gap:10, padding:"6px 0", borderBottom:"1px solid rgba(163,45,45,.12)"}}>
                <div style={{width:28,height:28,borderRadius:"50%",background:"#A32D2D",color:"#fff",display:"flex",alignItems:"center",justifyContent:"center",font:"600 11px var(--font-sans)",flexShrink:0}}>{initials(n)}</div>
                <div style={{flex:1, font:"500 13px var(--font-sans)"}}>{n}</div>
                <div style={{font:"11px var(--font-sans)", color:"var(--status-danger)", fontStyle:"italic"}}>Riesgo abandono</div>
              </div>
            ))}
          </div>

          {/* Recordatorios — yellow filled */}
          <div style={{background:"#FEFAEC", border:"2px solid var(--mod-funcional)", borderRadius:"var(--radius-lg)", padding:"1.25rem", marginBottom:"1rem"}}>
            <div style={{display:"flex",alignItems:"center",justifyContent:"space-between",marginBottom:".5rem"}}>
              <div style={{font:"600 11px var(--font-sans)", letterSpacing:".06em", textTransform:"uppercase", color:"var(--mod-funcional)"}}>🔔 Recordatorios — 7 alumnas</div>
              <button className="tp-btn tp-btn-small">📲 Recordar a todas</button>
            </div>
            {RECORD.map((r,i)=>(
              <div key={i} style={{display:"flex", alignItems:"center", gap:10, padding:"7px 0", borderBottom:"1px solid rgba(0,0,0,.06)"}}>
                <div className="tp-avatar" style={{width:30,height:30,fontSize:11}}>{initials(r.n)}</div>
                <div style={{flex:1}}>
                  <div style={{font:"500 13px var(--font-sans)"}}>{r.n}</div>
                  <div style={{font:"11px var(--font-sans)", color:r.c}}>{r.e}</div>
                </div>
                {r.m && <div style={{font:"600 12px var(--font-sans)"}}>{r.m}</div>}
                <span style={{padding:"4px 10px",border:"1px solid var(--mod-mat)",borderRadius:"var(--radius)",background:"var(--mod-mat-tint)",color:"var(--mod-mat)",font:"500 11px var(--font-sans)",whiteSpace:"nowrap"}}>💬 WA</span>
              </div>
            ))}
          </div>

          {/* Metrics */}
          <div style={{display:"grid", gridTemplateColumns:"repeat(4,1fr)", gap:10, marginBottom:"1rem"}}>
            <div className="tp-metric"><div className="tp-metric-label">Alumnas activas</div><div className="tp-metric-value violet">54</div></div>
            <div className="tp-metric"><div className="tp-metric-label">Pagaron Jun 2026</div><div className="tp-metric-value violet">29</div></div>
            <div className="tp-metric"><div className="tp-metric-label">Pendientes</div><div className="tp-metric-value warning">25</div></div>
            <div className="tp-metric"><div className="tp-metric-label">Recaudado Jun 2026</div><div className="tp-metric-value">$1.079.000</div></div>
          </div>

          {/* Full-width saturated blue CTA (uses Reformer's blue) */}
          <button style={{width:"100%", padding:"14px", background:"#2563EB", color:"#fff", border:"none", borderRadius:"var(--radius)", font:"600 14px var(--font-sans)", marginBottom:"1rem", cursor:"pointer"}}>
            📊 Ver informe mensual
          </button>

          {/* Notificaciones — green filled */}
          <div style={{background:"var(--mod-mat-tint)", borderLeft:"4px solid var(--mod-mat)", borderRadius:"var(--radius-lg)", padding:"1rem", display:"flex", alignItems:"center", gap:10}}>
            <div style={{fontSize:22}}>✅</div>
            <div>
              <div style={{font:"600 13px var(--font-sans)", color:"var(--mod-mat)"}}>Notificaciones activas</div>
              <div style={{font:"12px var(--font-sans)", color:"var(--fg-muted)"}}>Vas a recibir avisos cuando una alumna reporte un pago</div>
            </div>
          </div>
        </main>
      </div>
    </div>
  );
}

function ActualSidebar(){
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

Object.assign(window, { InicioActual });
