// App.jsx — wires up the student panel with state + routing.
const { useState, useEffect } = React;

function SPApp() {
  const [auth, setAuth] = useState(false);
  const [page, setPage] = useState("inicio");
  const [state, setState] = useState(window.SP_FIXTURE);
  const [modal, setModal] = useState(null);   // { kind:'aviso', mes }
  const [toast, setToast] = useState("");

  const showToast = (txt) => {
    setToast(txt);
    setTimeout(() => setToast(""), 2200);
  };

  // Derived: pago status icon for bottom nav
  const mes = window.SP_mesActual();
  const cobrado = state.pagos.find(p => p.mes === mes && p.pagado);
  const aviso   = state.avisos.find(av => av.mes === mes && av.estado === "pendiente");
  const pagoStatus = cobrado ? "ok" : aviso ? "aviso" : "sin";

  const handleAvisar = (mes) => setModal({ kind: "aviso", mes });
  const handleConfirmAviso = ({ mes, monto, nota }) => {
    setState(s => ({
      ...s,
      avisos: [...s.avisos, { mes, monto, nota, estado: "pendiente" }],
    }));
    setModal(null);
    showToast("✓ Aviso enviado a Amira");
  };

  if (!auth) {
    return (
      <div className="sp-app" data-screen-label="01 Login">
        <SPAuthScreen onLogin={() => { setAuth(true); showToast("¡Hola, María!"); }} />
        <SPToast text={toast} />
      </div>
    );
  }

  const screenLabel = {
    inicio:   "02 Inicio",
    horarios: "03 Horarios",
    pagos:    "04 Pagos",
    perfil:   "05 Perfil",
  }[page];

  return (
    <div className="sp-app" data-screen-label={screenLabel}>
      <SPHeader nombre={state.alumna.nombre.split(" ")[0]} onLogout={() => setAuth(false)} />
      <div className="sp-content">
        {page === "inicio"   && <SPInicio   state={state} onAvisar={handleAvisar} onEnableNotif={() => showToast("Notificaciones activadas")} />}
        {page === "horarios" && <SPHorarios state={state} />}
        {page === "pagos"    && <SPPagos    state={state} onAvisar={handleAvisar} />}
        {page === "perfil"   && <SPPerfil   state={state} onPhoto={() => showToast("Subí una foto")} onLogout={() => setAuth(false)} />}
      </div>
      <SPBottomNav current={page} onNav={setPage} pagoStatus={pagoStatus} />
      {modal?.kind === "aviso" && (
        <SPModalAvisoPago
          mes={modal.mes}
          defaultMonto={state.pagos[0]?.monto || 25000}
          onCancel={() => setModal(null)}
          onConfirm={handleConfirmAviso}
        />
      )}
      <SPToast text={toast} />
    </div>
  );
}

const root = ReactDOM.createRoot(document.getElementById("root"));
root.render(<SPApp />);
