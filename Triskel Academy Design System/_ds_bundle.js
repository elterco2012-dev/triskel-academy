/* @ds-bundle: {"format":3,"namespace":"TriskelAcademyDesignSystem_6ce449","components":[],"sourceHashes":{"ui_kits/student-panel/App.jsx":"69e3f427fc93","ui_kits/student-panel/StudentPrimitives.jsx":"9ffeed94c977","ui_kits/student-panel/StudentScreens.jsx":"c0452c955abc","ui_kits/student-panel/data.js":"34be1a6b195d","ui_kits/student-panel/ios-frame.jsx":"d67eb3ffe562","ui_kits/teacher-panel/InicioActual.jsx":"cf306fe9485e","ui_kits/teacher-panel/InicioPropuesta.jsx":"c83b8afd5568","ui_kits/teacher-panel/TeacherPrimitives.jsx":"bf48c07da5cc","ui_kits/teacher-panel/TeacherScreens.jsx":"f806753ac7c5","ui_kits/teacher-panel/browser-window.jsx":"2e3bb69bede4","ui_kits/teacher-panel/data.js":"1ce58c1993a7","ui_kits/teacher-panel/design-canvas.jsx":"bd8746af6e58"},"inlinedExternals":[],"unexposedExports":[]} */

(() => {

const __ds_ns = (window.TriskelAcademyDesignSystem_6ce449 = window.TriskelAcademyDesignSystem_6ce449 || {});

const __ds_scope = {};

(__ds_ns.__errors = __ds_ns.__errors || []);

// ui_kits/student-panel/App.jsx
try { (() => {
// App.jsx — wires up the student panel with state + routing.
const {
  useState,
  useEffect
} = React;
function SPApp() {
  const [auth, setAuth] = useState(false);
  const [page, setPage] = useState("inicio");
  const [state, setState] = useState(window.SP_FIXTURE);
  const [modal, setModal] = useState(null); // { kind:'aviso', mes }
  const [toast, setToast] = useState("");
  const showToast = txt => {
    setToast(txt);
    setTimeout(() => setToast(""), 2200);
  };

  // Derived: pago status icon for bottom nav
  const mes = window.SP_mesActual();
  const cobrado = state.pagos.find(p => p.mes === mes && p.pagado);
  const aviso = state.avisos.find(av => av.mes === mes && av.estado === "pendiente");
  const pagoStatus = cobrado ? "ok" : aviso ? "aviso" : "sin";
  const handleAvisar = mes => setModal({
    kind: "aviso",
    mes
  });
  const handleConfirmAviso = ({
    mes,
    monto,
    nota
  }) => {
    setState(s => ({
      ...s,
      avisos: [...s.avisos, {
        mes,
        monto,
        nota,
        estado: "pendiente"
      }]
    }));
    setModal(null);
    showToast("✓ Aviso enviado a Amira");
  };
  if (!auth) {
    return /*#__PURE__*/React.createElement("div", {
      className: "sp-app",
      "data-screen-label": "01 Login"
    }, /*#__PURE__*/React.createElement(SPAuthScreen, {
      onLogin: () => {
        setAuth(true);
        showToast("¡Hola, María!");
      }
    }), /*#__PURE__*/React.createElement(SPToast, {
      text: toast
    }));
  }
  const screenLabel = {
    inicio: "02 Inicio",
    horarios: "03 Horarios",
    pagos: "04 Pagos",
    perfil: "05 Perfil"
  }[page];
  return /*#__PURE__*/React.createElement("div", {
    className: "sp-app",
    "data-screen-label": screenLabel
  }, /*#__PURE__*/React.createElement(SPHeader, {
    nombre: state.alumna.nombre.split(" ")[0],
    onLogout: () => setAuth(false)
  }), /*#__PURE__*/React.createElement("div", {
    className: "sp-content"
  }, page === "inicio" && /*#__PURE__*/React.createElement(SPInicio, {
    state: state,
    onAvisar: handleAvisar,
    onEnableNotif: () => showToast("Notificaciones activadas")
  }), page === "horarios" && /*#__PURE__*/React.createElement(SPHorarios, {
    state: state
  }), page === "pagos" && /*#__PURE__*/React.createElement(SPPagos, {
    state: state,
    onAvisar: handleAvisar
  }), page === "perfil" && /*#__PURE__*/React.createElement(SPPerfil, {
    state: state,
    onPhoto: () => showToast("Subí una foto"),
    onLogout: () => setAuth(false)
  })), /*#__PURE__*/React.createElement(SPBottomNav, {
    current: page,
    onNav: setPage,
    pagoStatus: pagoStatus
  }), modal?.kind === "aviso" && /*#__PURE__*/React.createElement(SPModalAvisoPago, {
    mes: modal.mes,
    defaultMonto: state.pagos[0]?.monto || 25000,
    onCancel: () => setModal(null),
    onConfirm: handleConfirmAviso
  }), /*#__PURE__*/React.createElement(SPToast, {
    text: toast
  }));
}
const root = ReactDOM.createRoot(document.getElementById("root"));
root.render(/*#__PURE__*/React.createElement(SPApp, null));
})(); } catch (e) { __ds_ns.__errors.push({ path: "ui_kits/student-panel/App.jsx", error: String((e && e.message) || e) }); }

// ui_kits/student-panel/StudentPrimitives.jsx
try { (() => {
// Primitives.jsx — reusable building blocks for the student panel
// Loaded as a global Babel script. Exports onto window.

const SPCard = ({
  children,
  accent,
  style
}) => {
  const cls = "sp-card" + (accent ? ` sp-card-accent-${accent}` : "");
  return /*#__PURE__*/React.createElement("div", {
    className: cls,
    style: style
  }, children);
};
const SPCardTitle = ({
  children,
  icon
}) => /*#__PURE__*/React.createElement("div", {
  className: "sp-card-title"
}, icon ? /*#__PURE__*/React.createElement("span", null, icon) : null, /*#__PURE__*/React.createElement("span", null, children));
const SPChip = ({
  modalidad,
  children
}) => /*#__PURE__*/React.createElement("span", {
  className: `sp-chip ${window.SP_MOD_CHIP[modalidad] || ""}`
}, children || window.SP_MOD_LABEL[modalidad] || modalidad);
const SPScheduleItem = ({
  modalidad,
  title,
  sub,
  plan
}) => /*#__PURE__*/React.createElement("div", {
  className: "sp-sched-item"
}, /*#__PURE__*/React.createElement("div", {
  className: "sp-sched-dot",
  style: {
    background: window.SP_MOD_COLOR[modalidad] || "#666"
  }
}), /*#__PURE__*/React.createElement("div", {
  className: "sp-sched-info"
}, /*#__PURE__*/React.createElement("div", {
  className: "sp-sched-mod"
}, /*#__PURE__*/React.createElement("span", null, title), plan ? /*#__PURE__*/React.createElement(SPChip, {
  modalidad: modalidad
}, plan) : null), sub ? /*#__PURE__*/React.createElement("div", {
  className: "sp-sched-dia"
}, sub) : null));
const SPHeader = ({
  nombre,
  onLogout
}) => /*#__PURE__*/React.createElement("div", {
  className: "sp-header"
}, /*#__PURE__*/React.createElement("div", {
  className: "sp-header-logo"
}, /*#__PURE__*/React.createElement("img", {
  src: "../../assets/logo-triskel.png",
  alt: "Triskel"
})), /*#__PURE__*/React.createElement("div", null, /*#__PURE__*/React.createElement("div", {
  className: "sp-header-title"
}, nombre || "Mi cuenta"), /*#__PURE__*/React.createElement("div", {
  className: "sp-header-sub"
}, "Triskel Academy")), /*#__PURE__*/React.createElement("div", {
  className: "sp-header-right"
}, /*#__PURE__*/React.createElement("button", {
  className: "sp-icon-btn",
  onClick: onLogout,
  title: "Salir"
}, "\uD83D\uDEAA")));
const SPBottomNav = ({
  current,
  onNav,
  pagoStatus
}) => {
  const pagoIcon = pagoStatus === "aviso" ? "🔔" : pagoStatus === "sin" ? "⚠️" : "💳";
  const items = [{
    id: "inicio",
    ico: "🏠",
    lbl: "Inicio"
  }, {
    id: "horarios",
    ico: "📅",
    lbl: "Horarios"
  }, {
    id: "pagos",
    ico: pagoIcon,
    lbl: "Pagos"
  }, {
    id: "perfil",
    ico: "👤",
    lbl: "Perfil"
  }];
  return /*#__PURE__*/React.createElement("nav", {
    className: "sp-bnav"
  }, items.map(it => /*#__PURE__*/React.createElement("button", {
    key: it.id,
    className: "sp-nav-item" + (current === it.id ? " active" : ""),
    onClick: () => onNav(it.id)
  }, /*#__PURE__*/React.createElement("span", {
    className: "sp-nav-icon"
  }, it.ico), it.lbl)));
};
const SPNotifBanner = ({
  onEnable
}) => /*#__PURE__*/React.createElement("div", {
  className: "sp-notif-banner"
}, /*#__PURE__*/React.createElement("span", {
  className: "ico"
}, "\uD83D\uDD14"), /*#__PURE__*/React.createElement("div", {
  style: {
    flex: 1
  }
}, /*#__PURE__*/React.createElement("strong", null, "Activ\xE1 notificaciones"), /*#__PURE__*/React.createElement("span", null, "Te avisamos cuando se acerque tu cuota.")), /*#__PURE__*/React.createElement("button", {
  className: "sp-btn-notif",
  onClick: onEnable
}, "Activar"));
const SPToast = ({
  text
}) => text ? /*#__PURE__*/React.createElement("div", {
  className: "sp-toast"
}, text) : null;
const SPLoading = () => /*#__PURE__*/React.createElement("div", {
  className: "sp-loading"
}, /*#__PURE__*/React.createElement("div", {
  className: "sp-spinner"
}), "Cargando...");
Object.assign(window, {
  SPCard,
  SPCardTitle,
  SPChip,
  SPScheduleItem,
  SPHeader,
  SPBottomNav,
  SPNotifBanner,
  SPToast,
  SPLoading
});
})(); } catch (e) { __ds_ns.__errors.push({ path: "ui_kits/student-panel/StudentPrimitives.jsx", error: String((e && e.message) || e) }); }

// ui_kits/student-panel/StudentScreens.jsx
try { (() => {
// Screens.jsx — student panel screens
const {
  useState
} = React;

// ── Auth ────────────────────────────────────────────────────
const SPAuthScreen = ({
  onLogin
}) => {
  const [email, setEmail] = useState("maria.gonzalez@gmail.com");
  const [pwd, setPwd] = useState("••••••••");
  const [err, setErr] = useState("");
  const submit = () => {
    if (!email || !pwd) {
      setErr("Completá email y contraseña.");
      return;
    }
    setErr("");
    onLogin();
  };
  return /*#__PURE__*/React.createElement("div", {
    className: "sp-auth"
  }, /*#__PURE__*/React.createElement("img", {
    src: "../../assets/logo-triskel.png",
    className: "sp-auth-logo",
    alt: "Triskel"
  }), /*#__PURE__*/React.createElement("div", {
    className: "sp-auth-title"
  }, "Triskel Academy"), /*#__PURE__*/React.createElement("div", {
    className: "sp-auth-sub"
  }, "Mi Panel de Alumna"), /*#__PURE__*/React.createElement("div", {
    className: "sp-auth-card"
  }, /*#__PURE__*/React.createElement("label", null, "Email"), /*#__PURE__*/React.createElement("input", {
    className: "sp-input",
    type: "email",
    autoComplete: "email",
    value: email,
    onChange: e => setEmail(e.target.value)
  }), /*#__PURE__*/React.createElement("label", null, "Contrase\xF1a"), /*#__PURE__*/React.createElement("input", {
    className: "sp-input",
    type: "password",
    autoComplete: "current-password",
    value: pwd,
    onChange: e => setPwd(e.target.value),
    onKeyDown: e => e.key === 'Enter' && submit()
  }), /*#__PURE__*/React.createElement("button", {
    className: "sp-btn-primary",
    onClick: submit
  }, "Ingresar"), /*#__PURE__*/React.createElement("div", {
    className: "sp-auth-error"
  }, err)));
};

// ── Inicio ──────────────────────────────────────────────────
const SPInicio = ({
  state,
  onAvisar,
  onEnableNotif
}) => {
  const mes = window.SP_mesActual();
  const cobrado = state.pagos.find(p => p.mes === mes && p.pagado);
  const aviso = state.avisos.find(av => av.mes === mes && av.estado === "pendiente");
  const inscs = state.inscripciones || [];

  // Today's class
  const today = new Date().getDay();
  const dayMap = {
    1: "lun",
    2: "mar",
    3: "mie",
    4: "jue",
    5: "vie"
  };
  const todayKey = dayMap[today];
  const hoy = inscs.filter(i => i.dia === todayKey);
  let pagoCard;
  if (cobrado) {
    pagoCard = /*#__PURE__*/React.createElement(SPCard, {
      accent: "mat"
    }, /*#__PURE__*/React.createElement("div", {
      style: {
        display: "flex",
        alignItems: "center",
        gap: "0.5rem"
      }
    }, /*#__PURE__*/React.createElement("div", {
      style: {
        fontSize: "28px"
      }
    }, "\u2705"), /*#__PURE__*/React.createElement("div", null, /*#__PURE__*/React.createElement("div", {
      style: {
        font: "var(--type-caption)"
      }
    }, "Cuota ", window.SP_mesLabel(mes)), /*#__PURE__*/React.createElement("div", {
      className: "sp-pago-estado cobrado"
    }, "\xA1Pagada!"), cobrado.monto && /*#__PURE__*/React.createElement("div", {
      style: {
        font: "var(--type-caption)"
      }
    }, window.SP_money(cobrado.monto)), cobrado.nota && /*#__PURE__*/React.createElement("div", {
      style: {
        font: "11px var(--font-sans)",
        color: "var(--fg-muted)",
        fontStyle: "italic",
        marginTop: "0.1rem"
      }
    }, "\"", cobrado.nota, "\""))));
  } else if (aviso) {
    pagoCard = /*#__PURE__*/React.createElement(SPCard, {
      accent: "warning"
    }, /*#__PURE__*/React.createElement("div", {
      style: {
        display: "flex",
        alignItems: "center",
        gap: "0.5rem"
      }
    }, /*#__PURE__*/React.createElement("div", {
      style: {
        fontSize: "28px"
      }
    }, "\u23F3"), /*#__PURE__*/React.createElement("div", null, /*#__PURE__*/React.createElement("div", {
      style: {
        font: "var(--type-caption)"
      }
    }, "Cuota ", window.SP_mesLabel(mes)), /*#__PURE__*/React.createElement("div", {
      className: "sp-pago-estado pendiente",
      style: {
        fontSize: "15px"
      }
    }, "Pendiente de aprobaci\xF3n"), /*#__PURE__*/React.createElement("div", {
      style: {
        font: "12px var(--font-sans)",
        color: "var(--fg-muted)"
      }
    }, "Avisaste que pagaste \xB7 Amira est\xE1 revisando"))));
  } else {
    pagoCard = /*#__PURE__*/React.createElement(SPCard, {
      accent: "danger"
    }, /*#__PURE__*/React.createElement("div", {
      style: {
        font: "var(--type-caption)",
        marginBottom: "0.4rem"
      }
    }, "Cuota ", window.SP_mesLabel(mes)), /*#__PURE__*/React.createElement("div", {
      className: "sp-pago-estado sin",
      style: {
        fontSize: "15px",
        marginBottom: "0.75rem"
      }
    }, "\u26A0\uFE0F Sin pago registrado"), /*#__PURE__*/React.createElement("button", {
      className: "sp-btn-pague",
      onClick: () => onAvisar(mes)
    }, "\uD83D\uDCB3 Avisar que pagu\xE9"));
  }
  return /*#__PURE__*/React.createElement(React.Fragment, null, /*#__PURE__*/React.createElement(SPNotifBanner, {
    onEnable: onEnableNotif
  }), pagoCard, hoy.length > 0 && /*#__PURE__*/React.createElement(SPCard, null, /*#__PURE__*/React.createElement(SPCardTitle, {
    icon: "\uD83D\uDCCD"
  }, "Clase de hoy"), hoy.map(i => /*#__PURE__*/React.createElement(SPScheduleItem, {
    key: i.id,
    modalidad: i.modalidad,
    title: `${window.SP_MOD_LABEL[i.modalidad]}${i.plan_nombre ? ' · ' + i.plan_nombre : ''}`,
    sub: i.horario
  }))), /*#__PURE__*/React.createElement(SPCard, null, /*#__PURE__*/React.createElement(SPCardTitle, {
    icon: "\uD83D\uDCCB"
  }, "Mi inscripci\xF3n"), inscs.length ? inscs.map(i => /*#__PURE__*/React.createElement(SPScheduleItem, {
    key: i.id,
    modalidad: i.modalidad,
    title: `${window.SP_MOD_LABEL[i.modalidad]}${i.plan_nombre ? ' · ' + i.plan_nombre : ''}`,
    sub: `${window.SP_DIA_LABEL[i.dia] || i.dia}${i.horario ? ' · ' + i.horario : ''}`
  })) : /*#__PURE__*/React.createElement("div", {
    style: {
      font: "13px var(--font-sans)",
      color: "var(--fg-muted)"
    }
  }, "Sin inscripciones activas.")));
};

// ── Horarios ────────────────────────────────────────────────
const SPHorarios = ({
  state
}) => {
  const inscs = state.inscripciones || [];
  if (!inscs.length) {
    return /*#__PURE__*/React.createElement(SPCard, {
      style: {
        textAlign: "center",
        padding: "2rem"
      }
    }, /*#__PURE__*/React.createElement("div", {
      style: {
        fontSize: "32px",
        marginBottom: "0.5rem"
      }
    }, "\uD83D\uDCC5"), /*#__PURE__*/React.createElement("div", {
      style: {
        font: "14px var(--font-sans)",
        color: "var(--fg-muted)"
      }
    }, "No ten\xE9s inscripciones activas.", /*#__PURE__*/React.createElement("br", null), "Habl\xE1 con Amira para inscribirte."));
  }
  const grouped = {};
  inscs.forEach(i => {
    (grouped[i.dia] ||= []).push(i);
  });
  const days = Object.keys(grouped).sort((a, b) => window.SP_DIA_ORDER[a] - window.SP_DIA_ORDER[b]);
  return /*#__PURE__*/React.createElement(React.Fragment, null, days.map(d => /*#__PURE__*/React.createElement(SPCard, {
    key: d
  }, /*#__PURE__*/React.createElement(SPCardTitle, {
    icon: "\uD83D\uDCC5"
  }, window.SP_DIA_LABEL[d] || d), grouped[d].map(i => /*#__PURE__*/React.createElement(SPScheduleItem, {
    key: i.id,
    modalidad: i.modalidad,
    title: window.SP_MOD_LABEL[i.modalidad],
    plan: i.plan_nombre,
    sub: i.horario ? `🕐 ${i.horario}` : null
  })))));
};

// ── Pagos ───────────────────────────────────────────────────
const SPPagos = ({
  state,
  onAvisar
}) => {
  const mes = window.SP_mesActual();
  const cobrado = state.pagos.find(p => p.mes === mes && p.pagado);
  const aviso = state.avisos.find(av => av.mes === mes && av.estado === "pendiente");
  return /*#__PURE__*/React.createElement(React.Fragment, null, /*#__PURE__*/React.createElement(SPCard, {
    accent: cobrado ? "mat" : aviso ? "warning" : "danger"
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      font: "11px var(--font-sans)",
      fontWeight: 700,
      color: "var(--fg-muted)",
      textTransform: "uppercase",
      letterSpacing: ".05em"
    }
  }, "Cuota ", window.SP_mesLabel(mes)), /*#__PURE__*/React.createElement("div", {
    className: `sp-pago-estado ${cobrado ? 'cobrado' : aviso ? 'pendiente' : 'sin'}`
  }, cobrado ? "✅ ¡Pagada!" : aviso ? "⏳ Pendiente de aprobación" : "⚠️ Sin pago registrado"), !cobrado && !aviso && /*#__PURE__*/React.createElement("button", {
    className: "sp-btn-pague",
    onClick: () => onAvisar(mes),
    style: {
      marginTop: ".5rem"
    }
  }, "\uD83D\uDCB3 Avisar que pagu\xE9"), aviso && /*#__PURE__*/React.createElement("div", {
    style: {
      font: "12px var(--font-sans)",
      color: "var(--fg-muted)",
      marginTop: ".4rem"
    }
  }, "Amira lo est\xE1 revisando.")), /*#__PURE__*/React.createElement(SPCard, null, /*#__PURE__*/React.createElement(SPCardTitle, {
    icon: "\uD83D\uDCDA"
  }, "Historial"), state.pagos.map(p => /*#__PURE__*/React.createElement("div", {
    className: "sp-hist-row",
    key: p.mes
  }, /*#__PURE__*/React.createElement("span", {
    className: "sp-hist-mes"
  }, window.SP_mesLabel(p.mes)), /*#__PURE__*/React.createElement("span", {
    className: "sp-hist-monto"
  }, window.SP_money(p.monto))))));
};

// ── Perfil ──────────────────────────────────────────────────
const SPPerfil = ({
  state,
  onPhoto,
  onLogout
}) => {
  const a = state.alumna;
  return /*#__PURE__*/React.createElement(React.Fragment, null, /*#__PURE__*/React.createElement(SPCard, null, /*#__PURE__*/React.createElement("div", {
    className: "sp-profile-photo-wrap"
  }, /*#__PURE__*/React.createElement("div", {
    className: "sp-profile-photo"
  }, a.foto ? /*#__PURE__*/React.createElement("img", {
    src: a.foto,
    alt: ""
  }) : "👤"), /*#__PURE__*/React.createElement("button", {
    onClick: onPhoto,
    style: {
      marginTop: ".5rem",
      font: "12px var(--font-sans)",
      color: "var(--brand-violet)",
      background: "none",
      border: "1px solid var(--brand-violet)",
      borderRadius: "20px",
      padding: ".2rem .75rem",
      cursor: "pointer"
    }
  }, "Cambiar foto"), /*#__PURE__*/React.createElement("div", {
    className: "sp-profile-name"
  }, a.nombre), /*#__PURE__*/React.createElement("div", {
    className: "sp-profile-email"
  }, a.email)), /*#__PURE__*/React.createElement("div", {
    className: "sp-profile-row"
  }, /*#__PURE__*/React.createElement("span", {
    className: "sp-profile-label"
  }, "Tel\xE9fono"), /*#__PURE__*/React.createElement("span", {
    className: "sp-profile-val"
  }, a.tel || "—")), /*#__PURE__*/React.createElement("div", {
    className: "sp-profile-row"
  }, /*#__PURE__*/React.createElement("span", {
    className: "sp-profile-label"
  }, "D\xEDa de pago"), /*#__PURE__*/React.createElement("span", {
    className: "sp-profile-val"
  }, "D\xEDa ", a.dia_pago || "—", " del mes")), /*#__PURE__*/React.createElement("div", {
    className: "sp-profile-row"
  }, /*#__PURE__*/React.createElement("span", {
    className: "sp-profile-label"
  }, "Modalidades"), /*#__PURE__*/React.createElement("span", {
    style: {
      display: "flex",
      gap: "4px",
      flexWrap: "wrap"
    }
  }, [...new Set(state.inscripciones.map(i => i.modalidad))].map(m => /*#__PURE__*/React.createElement(SPChip, {
    key: m,
    modalidad: m
  }))))), /*#__PURE__*/React.createElement(SPCard, null, /*#__PURE__*/React.createElement(SPCardTitle, {
    icon: "\u2699\uFE0F"
  }, "Cuenta"), /*#__PURE__*/React.createElement("button", {
    className: "sp-btn-pague",
    style: {
      background: "#fff",
      color: "var(--brand-violet)",
      border: "1.5px solid var(--brand-violet)"
    },
    onClick: onLogout
  }, "\uD83D\uDEAA Cerrar sesi\xF3n")));
};

// ── Modal Aviso Pago ────────────────────────────────────────
const SPModalAvisoPago = ({
  mes,
  defaultMonto,
  onCancel,
  onConfirm
}) => {
  const [monto, setMonto] = useState(defaultMonto || 25000);
  const [nota, setNota] = useState("");
  return /*#__PURE__*/React.createElement("div", {
    className: "sp-modal-overlay",
    onClick: e => e.target === e.currentTarget && onCancel()
  }, /*#__PURE__*/React.createElement("div", {
    className: "sp-modal-sheet",
    onClick: e => e.stopPropagation()
  }, /*#__PURE__*/React.createElement("div", {
    className: "sp-modal-handle"
  }), /*#__PURE__*/React.createElement("div", {
    className: "sp-modal-title"
  }, "\uD83D\uDCB3 Avisar pago"), /*#__PURE__*/React.createElement("div", {
    style: {
      font: "13px var(--font-sans)",
      color: "var(--fg-muted)",
      marginBottom: ".5rem"
    }
  }, "Complet\xE1 los datos de tu pago y Amira lo confirmar\xE1."), /*#__PURE__*/React.createElement("div", {
    style: {
      font: "13px var(--font-sans)",
      fontWeight: 600,
      color: "var(--brand-violet)",
      marginBottom: ".5rem"
    }
  }, window.SP_mesLabel(mes)), /*#__PURE__*/React.createElement("label", {
    className: "sp-modal-label"
  }, "Monto abonado ", /*#__PURE__*/React.createElement("span", {
    style: {
      fontWeight: 400,
      color: "#aaa"
    }
  }, "(pod\xE9s modificarlo)")), /*#__PURE__*/React.createElement("input", {
    className: "sp-input",
    type: "number",
    value: monto,
    onChange: e => setMonto(Number(e.target.value))
  }), /*#__PURE__*/React.createElement("label", {
    className: "sp-modal-label"
  }, "Nota (opcional)"), /*#__PURE__*/React.createElement("input", {
    className: "sp-input",
    type: "text",
    value: nota,
    placeholder: "Ej: Transfer\xED al CBU, operaci\xF3n 123456",
    onChange: e => setNota(e.target.value),
    maxLength: 200
  }), /*#__PURE__*/React.createElement("div", {
    className: "sp-modal-row"
  }, /*#__PURE__*/React.createElement("button", {
    className: "sp-btn-cancel",
    onClick: onCancel
  }, "Cancelar"), /*#__PURE__*/React.createElement("button", {
    className: "sp-btn-confirm",
    onClick: () => onConfirm({
      mes,
      monto,
      nota
    })
  }, "Avisar pago \u2713"))));
};
Object.assign(window, {
  SPAuthScreen,
  SPInicio,
  SPHorarios,
  SPPagos,
  SPPerfil,
  SPModalAvisoPago
});
})(); } catch (e) { __ds_ns.__errors.push({ path: "ui_kits/student-panel/StudentScreens.jsx", error: String((e && e.message) || e) }); }

// ui_kits/student-panel/data.js
try { (() => {
// data.js — sample fixture data for the student panel kit
// Shape mirrors what `triskel_get_mi_ficha` returns from Supabase.

window.SP_FIXTURE = {
  alumna: {
    nombre: "María González",
    email: "maria.gonzalez@gmail.com",
    tel: "5491140012345",
    dia_pago: 10,
    nacimiento: "1988-03-21",
    foto: null
  },
  inscripciones: [{
    id: 1,
    modalidad: "reformer",
    dia: "lun",
    horario: "09:30–10:30",
    plan_nombre: "Plan 2 días"
  }, {
    id: 2,
    modalidad: "reformer",
    dia: "mie",
    horario: "09:30–10:30",
    plan_nombre: "Plan 2 días"
  }, {
    id: 3,
    modalidad: "mat",
    dia: "vie",
    horario: "18:00–19:00",
    plan_nombre: null
  }],
  // Current month default: pending (no aviso yet) → "Sin pago registrado"
  pagos: [{
    mes: "2025-10",
    pagado: true,
    monto: 25000,
    nota: "Transferencia 8/10"
  }, {
    mes: "2025-09",
    pagado: true,
    monto: 25000,
    nota: null
  }, {
    mes: "2025-08",
    pagado: true,
    monto: 25000,
    nota: null
  }, {
    mes: "2025-07",
    pagado: true,
    monto: 22000,
    nota: null
  }],
  avisos: []
};
window.SP_DIA_LABEL = {
  lun: "Lunes",
  mar: "Martes",
  mie: "Miércoles",
  jue: "Jueves",
  vie: "Viernes"
};
window.SP_DIA_ORDER = {
  lun: 0,
  mar: 1,
  mie: 2,
  jue: 3,
  vie: 4
};
window.SP_MOD_COLOR = {
  mat: "#27ae60",
  reformer: "#2980b9",
  funcional: "#e67e22"
};
window.SP_MOD_CHIP = {
  mat: "sp-chip-mat",
  reformer: "sp-chip-reformer",
  funcional: "sp-chip-funcional"
};
window.SP_MOD_LABEL = {
  mat: "Mat",
  reformer: "Reformer",
  funcional: "Funcional"
};
window.SP_mesLabel = mesStr => {
  if (!mesStr) return "";
  const [y, m] = mesStr.split("-");
  return new Date(y, m - 1, 1).toLocaleDateString("es-AR", {
    month: "long",
    year: "numeric"
  });
};
window.SP_mesActual = () => new Date().toISOString().slice(0, 7);
window.SP_money = n => "$" + Number(n || 0).toLocaleString("es-AR");
})(); } catch (e) { __ds_ns.__errors.push({ path: "ui_kits/student-panel/data.js", error: String((e && e.message) || e) }); }

// ui_kits/student-panel/ios-frame.jsx
try { (() => {
// iOS.jsx — Simplified iOS 26 (Liquid Glass) device frame
// Based on the iOS 26 UI Kit + Figma status bar spec. No assets, no deps.
// Exports: IOSDevice, IOSStatusBar, IOSNavBar, IOSGlassPill, IOSList, IOSListRow, IOSKeyboard

// ─────────────────────────────────────────────────────────────
// Status bar
// ─────────────────────────────────────────────────────────────
function IOSStatusBar({
  dark = false,
  time = '9:41'
}) {
  const c = dark ? '#fff' : '#000';
  return /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      gap: 154,
      alignItems: 'center',
      justifyContent: 'center',
      padding: '21px 24px 19px',
      boxSizing: 'border-box',
      position: 'relative',
      zIndex: 20,
      width: '100%'
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      flex: 1,
      height: 22,
      display: 'flex',
      alignItems: 'center',
      justifyContent: 'center',
      paddingTop: 1.5
    }
  }, /*#__PURE__*/React.createElement("span", {
    style: {
      fontFamily: '-apple-system, "SF Pro", system-ui',
      fontWeight: 590,
      fontSize: 17,
      lineHeight: '22px',
      color: c
    }
  }, time)), /*#__PURE__*/React.createElement("div", {
    style: {
      flex: 1,
      height: 22,
      display: 'flex',
      alignItems: 'center',
      justifyContent: 'center',
      gap: 7,
      paddingTop: 1,
      paddingRight: 1
    }
  }, /*#__PURE__*/React.createElement("svg", {
    width: "19",
    height: "12",
    viewBox: "0 0 19 12"
  }, /*#__PURE__*/React.createElement("rect", {
    x: "0",
    y: "7.5",
    width: "3.2",
    height: "4.5",
    rx: "0.7",
    fill: c
  }), /*#__PURE__*/React.createElement("rect", {
    x: "4.8",
    y: "5",
    width: "3.2",
    height: "7",
    rx: "0.7",
    fill: c
  }), /*#__PURE__*/React.createElement("rect", {
    x: "9.6",
    y: "2.5",
    width: "3.2",
    height: "9.5",
    rx: "0.7",
    fill: c
  }), /*#__PURE__*/React.createElement("rect", {
    x: "14.4",
    y: "0",
    width: "3.2",
    height: "12",
    rx: "0.7",
    fill: c
  })), /*#__PURE__*/React.createElement("svg", {
    width: "17",
    height: "12",
    viewBox: "0 0 17 12"
  }, /*#__PURE__*/React.createElement("path", {
    d: "M8.5 3.2C10.8 3.2 12.9 4.1 14.4 5.6L15.5 4.5C13.7 2.7 11.2 1.5 8.5 1.5C5.8 1.5 3.3 2.7 1.5 4.5L2.6 5.6C4.1 4.1 6.2 3.2 8.5 3.2Z",
    fill: c
  }), /*#__PURE__*/React.createElement("path", {
    d: "M8.5 6.8C9.9 6.8 11.1 7.3 12 8.2L13.1 7.1C11.8 5.9 10.2 5.1 8.5 5.1C6.8 5.1 5.2 5.9 3.9 7.1L5 8.2C5.9 7.3 7.1 6.8 8.5 6.8Z",
    fill: c
  }), /*#__PURE__*/React.createElement("circle", {
    cx: "8.5",
    cy: "10.5",
    r: "1.5",
    fill: c
  })), /*#__PURE__*/React.createElement("svg", {
    width: "27",
    height: "13",
    viewBox: "0 0 27 13"
  }, /*#__PURE__*/React.createElement("rect", {
    x: "0.5",
    y: "0.5",
    width: "23",
    height: "12",
    rx: "3.5",
    stroke: c,
    strokeOpacity: "0.35",
    fill: "none"
  }), /*#__PURE__*/React.createElement("rect", {
    x: "2",
    y: "2",
    width: "20",
    height: "9",
    rx: "2",
    fill: c
  }), /*#__PURE__*/React.createElement("path", {
    d: "M25 4.5V8.5C25.8 8.2 26.5 7.2 26.5 6.5C26.5 5.8 25.8 4.8 25 4.5Z",
    fill: c,
    fillOpacity: "0.4"
  }))));
}

// ─────────────────────────────────────────────────────────────
// Liquid glass pill — blur + tint + shine
// ─────────────────────────────────────────────────────────────
function IOSGlassPill({
  children,
  dark = false,
  style = {}
}) {
  return /*#__PURE__*/React.createElement("div", {
    style: {
      height: 44,
      minWidth: 44,
      borderRadius: 9999,
      position: 'relative',
      overflow: 'hidden',
      display: 'flex',
      alignItems: 'center',
      justifyContent: 'center',
      boxShadow: dark ? '0 2px 6px rgba(0,0,0,0.35), 0 6px 16px rgba(0,0,0,0.2)' : '0 1px 3px rgba(0,0,0,0.07), 0 3px 10px rgba(0,0,0,0.06)',
      ...style
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      position: 'absolute',
      inset: 0,
      borderRadius: 9999,
      backdropFilter: 'blur(12px) saturate(180%)',
      WebkitBackdropFilter: 'blur(12px) saturate(180%)',
      background: dark ? 'rgba(120,120,128,0.28)' : 'rgba(255,255,255,0.5)'
    }
  }), /*#__PURE__*/React.createElement("div", {
    style: {
      position: 'absolute',
      inset: 0,
      borderRadius: 9999,
      boxShadow: dark ? 'inset 1.5px 1.5px 1px rgba(255,255,255,0.15), inset -1px -1px 1px rgba(255,255,255,0.08)' : 'inset 1.5px 1.5px 1px rgba(255,255,255,0.7), inset -1px -1px 1px rgba(255,255,255,0.4)',
      border: dark ? '0.5px solid rgba(255,255,255,0.15)' : '0.5px solid rgba(0,0,0,0.06)'
    }
  }), /*#__PURE__*/React.createElement("div", {
    style: {
      position: 'relative',
      zIndex: 1,
      display: 'flex',
      alignItems: 'center',
      padding: '0 4px'
    }
  }, children));
}

// ─────────────────────────────────────────────────────────────
// Navigation bar — glass pills + large title
// ─────────────────────────────────────────────────────────────
function IOSNavBar({
  title = 'Title',
  dark = false,
  trailingIcon = true
}) {
  const muted = dark ? 'rgba(255,255,255,0.6)' : '#404040';
  const text = dark ? '#fff' : '#000';
  const pillIcon = content => /*#__PURE__*/React.createElement(IOSGlassPill, {
    dark: dark
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      width: 36,
      height: 36,
      display: 'flex',
      alignItems: 'center',
      justifyContent: 'center'
    }
  }, content));
  return /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      flexDirection: 'column',
      gap: 10,
      paddingTop: 62,
      paddingBottom: 10,
      position: 'relative',
      zIndex: 5
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      alignItems: 'center',
      justifyContent: 'space-between',
      padding: '0 16px'
    }
  }, pillIcon(/*#__PURE__*/React.createElement("svg", {
    width: "12",
    height: "20",
    viewBox: "0 0 12 20",
    fill: "none",
    style: {
      marginLeft: -1
    }
  }, /*#__PURE__*/React.createElement("path", {
    d: "M10 2L2 10l8 8",
    stroke: muted,
    strokeWidth: "2.5",
    strokeLinecap: "round",
    strokeLinejoin: "round"
  }))), trailingIcon && pillIcon(/*#__PURE__*/React.createElement("svg", {
    width: "22",
    height: "6",
    viewBox: "0 0 22 6"
  }, /*#__PURE__*/React.createElement("circle", {
    cx: "3",
    cy: "3",
    r: "2.5",
    fill: muted
  }), /*#__PURE__*/React.createElement("circle", {
    cx: "11",
    cy: "3",
    r: "2.5",
    fill: muted
  }), /*#__PURE__*/React.createElement("circle", {
    cx: "19",
    cy: "3",
    r: "2.5",
    fill: muted
  })))), /*#__PURE__*/React.createElement("div", {
    style: {
      padding: '0 16px',
      fontFamily: '-apple-system, system-ui',
      fontSize: 34,
      fontWeight: 700,
      lineHeight: '41px',
      color: text,
      letterSpacing: 0.4
    }
  }, title));
}

// ─────────────────────────────────────────────────────────────
// Grouped list (inset card, r:26) + row (52px)
// ─────────────────────────────────────────────────────────────
function IOSListRow({
  title,
  detail,
  icon,
  chevron = true,
  isLast = false,
  dark = false
}) {
  const text = dark ? '#fff' : '#000';
  const sec = dark ? 'rgba(235,235,245,0.6)' : 'rgba(60,60,67,0.6)';
  const ter = dark ? 'rgba(235,235,245,0.3)' : 'rgba(60,60,67,0.3)';
  const sep = dark ? 'rgba(84,84,88,0.65)' : 'rgba(60,60,67,0.12)';
  return /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      alignItems: 'center',
      minHeight: 52,
      padding: '0 16px',
      position: 'relative',
      fontFamily: '-apple-system, system-ui',
      fontSize: 17,
      letterSpacing: -0.43
    }
  }, icon && /*#__PURE__*/React.createElement("div", {
    style: {
      width: 30,
      height: 30,
      borderRadius: 7,
      background: icon,
      marginRight: 12,
      flexShrink: 0
    }
  }), /*#__PURE__*/React.createElement("div", {
    style: {
      flex: 1,
      color: text
    }
  }, title), detail && /*#__PURE__*/React.createElement("span", {
    style: {
      color: sec,
      marginRight: 6
    }
  }, detail), chevron && /*#__PURE__*/React.createElement("svg", {
    width: "8",
    height: "14",
    viewBox: "0 0 8 14",
    style: {
      flexShrink: 0
    }
  }, /*#__PURE__*/React.createElement("path", {
    d: "M1 1l6 6-6 6",
    stroke: ter,
    strokeWidth: "2",
    fill: "none",
    strokeLinecap: "round",
    strokeLinejoin: "round"
  })), !isLast && /*#__PURE__*/React.createElement("div", {
    style: {
      position: 'absolute',
      bottom: 0,
      right: 0,
      left: icon ? 58 : 16,
      height: 0.5,
      background: sep
    }
  }));
}
function IOSList({
  header,
  children,
  dark = false
}) {
  const hc = dark ? 'rgba(235,235,245,0.6)' : 'rgba(60,60,67,0.6)';
  const bg = dark ? '#1C1C1E' : '#fff';
  return /*#__PURE__*/React.createElement("div", null, header && /*#__PURE__*/React.createElement("div", {
    style: {
      fontFamily: '-apple-system, system-ui',
      fontSize: 13,
      color: hc,
      textTransform: 'uppercase',
      padding: '8px 36px 6px',
      letterSpacing: -0.08
    }
  }, header), /*#__PURE__*/React.createElement("div", {
    style: {
      background: bg,
      borderRadius: 26,
      margin: '0 16px',
      overflow: 'hidden'
    }
  }, children));
}

// ─────────────────────────────────────────────────────────────
// Device frame
// ─────────────────────────────────────────────────────────────
function IOSDevice({
  children,
  width = 402,
  height = 874,
  dark = false,
  title,
  keyboard = false
}) {
  return /*#__PURE__*/React.createElement("div", {
    style: {
      width,
      height,
      borderRadius: 48,
      overflow: 'hidden',
      position: 'relative',
      background: dark ? '#000' : '#F2F2F7',
      boxShadow: '0 40px 80px rgba(0,0,0,0.18), 0 0 0 1px rgba(0,0,0,0.12)',
      fontFamily: '-apple-system, system-ui, sans-serif',
      WebkitFontSmoothing: 'antialiased'
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      position: 'absolute',
      top: 11,
      left: '50%',
      transform: 'translateX(-50%)',
      width: 126,
      height: 37,
      borderRadius: 24,
      background: '#000',
      zIndex: 50
    }
  }), /*#__PURE__*/React.createElement("div", {
    style: {
      position: 'absolute',
      top: 0,
      left: 0,
      right: 0,
      zIndex: 10
    }
  }, /*#__PURE__*/React.createElement(IOSStatusBar, {
    dark: dark
  })), /*#__PURE__*/React.createElement("div", {
    style: {
      height: '100%',
      display: 'flex',
      flexDirection: 'column'
    }
  }, title !== undefined && /*#__PURE__*/React.createElement(IOSNavBar, {
    title: title,
    dark: dark
  }), /*#__PURE__*/React.createElement("div", {
    style: {
      flex: 1,
      overflow: 'auto'
    }
  }, children), keyboard && /*#__PURE__*/React.createElement(IOSKeyboard, {
    dark: dark
  })), /*#__PURE__*/React.createElement("div", {
    style: {
      position: 'absolute',
      bottom: 0,
      left: 0,
      right: 0,
      zIndex: 60,
      height: 34,
      display: 'flex',
      justifyContent: 'center',
      alignItems: 'flex-end',
      paddingBottom: 8,
      pointerEvents: 'none'
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      width: 139,
      height: 5,
      borderRadius: 100,
      background: dark ? 'rgba(255,255,255,0.7)' : 'rgba(0,0,0,0.25)'
    }
  })));
}

// ─────────────────────────────────────────────────────────────
// Keyboard — iOS 26 liquid glass
// ─────────────────────────────────────────────────────────────
function IOSKeyboard({
  dark = false
}) {
  const glyph = dark ? 'rgba(255,255,255,0.7)' : '#595959';
  const sugg = dark ? 'rgba(255,255,255,0.6)' : '#333';
  const keyBg = dark ? 'rgba(255,255,255,0.22)' : 'rgba(255,255,255,0.85)';

  // special-key icons
  const icons = {
    shift: /*#__PURE__*/React.createElement("svg", {
      width: "19",
      height: "17",
      viewBox: "0 0 19 17"
    }, /*#__PURE__*/React.createElement("path", {
      d: "M9.5 1L1 9.5h4.5V16h8V9.5H18L9.5 1z",
      fill: glyph
    })),
    del: /*#__PURE__*/React.createElement("svg", {
      width: "23",
      height: "17",
      viewBox: "0 0 23 17"
    }, /*#__PURE__*/React.createElement("path", {
      d: "M7 1h13a2 2 0 012 2v11a2 2 0 01-2 2H7l-6-7.5L7 1z",
      fill: "none",
      stroke: glyph,
      strokeWidth: "1.6",
      strokeLinejoin: "round"
    }), /*#__PURE__*/React.createElement("path", {
      d: "M10 5l7 7M17 5l-7 7",
      stroke: glyph,
      strokeWidth: "1.6",
      strokeLinecap: "round"
    })),
    ret: /*#__PURE__*/React.createElement("svg", {
      width: "20",
      height: "14",
      viewBox: "0 0 20 14"
    }, /*#__PURE__*/React.createElement("path", {
      d: "M18 1v6H4m0 0l4-4M4 7l4 4",
      fill: "none",
      stroke: "#fff",
      strokeWidth: "1.8",
      strokeLinecap: "round",
      strokeLinejoin: "round"
    }))
  };
  const key = (content, {
    w,
    flex,
    ret,
    fs = 25,
    k
  } = {}) => /*#__PURE__*/React.createElement("div", {
    key: k,
    style: {
      height: 42,
      borderRadius: 8.5,
      flex: flex ? 1 : undefined,
      width: w,
      minWidth: 0,
      background: ret ? '#08f' : keyBg,
      boxShadow: '0 1px 0 rgba(0,0,0,0.075)',
      display: 'flex',
      alignItems: 'center',
      justifyContent: 'center',
      fontFamily: '-apple-system, "SF Compact", system-ui',
      fontSize: fs,
      fontWeight: 458,
      color: ret ? '#fff' : glyph
    }
  }, content);
  const row = (keys, pad = 0) => /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      gap: 6.5,
      justifyContent: 'center',
      padding: `0 ${pad}px`
    }
  }, keys.map(l => key(l, {
    flex: true,
    k: l
  })));
  return /*#__PURE__*/React.createElement("div", {
    style: {
      position: 'relative',
      zIndex: 15,
      borderRadius: 27,
      overflow: 'hidden',
      padding: '11px 0 2px',
      display: 'flex',
      flexDirection: 'column',
      alignItems: 'center',
      boxShadow: dark ? '0 -2px 20px rgba(0,0,0,0.09)' : '0 -1px 6px rgba(0,0,0,0.018), 0 -3px 20px rgba(0,0,0,0.012)'
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      position: 'absolute',
      inset: 0,
      borderRadius: 27,
      backdropFilter: 'blur(12px) saturate(180%)',
      WebkitBackdropFilter: 'blur(12px) saturate(180%)',
      background: dark ? 'rgba(120,120,128,0.14)' : 'rgba(255,255,255,0.25)'
    }
  }), /*#__PURE__*/React.createElement("div", {
    style: {
      position: 'absolute',
      inset: 0,
      borderRadius: 27,
      boxShadow: dark ? 'inset 1.5px 1.5px 1px rgba(255,255,255,0.15)' : 'inset 1.5px 1.5px 1px rgba(255,255,255,0.7), inset -1px -1px 1px rgba(255,255,255,0.4)',
      border: dark ? '0.5px solid rgba(255,255,255,0.15)' : '0.5px solid rgba(0,0,0,0.06)',
      pointerEvents: 'none'
    }
  }), /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      gap: 20,
      alignItems: 'center',
      padding: '8px 22px 13px',
      width: '100%',
      boxSizing: 'border-box',
      position: 'relative'
    }
  }, ['"The"', 'the', 'to'].map((w, i) => /*#__PURE__*/React.createElement(React.Fragment, {
    key: i
  }, i > 0 && /*#__PURE__*/React.createElement("div", {
    style: {
      width: 1,
      height: 25,
      background: '#ccc',
      opacity: 0.3
    }
  }), /*#__PURE__*/React.createElement("div", {
    style: {
      flex: 1,
      textAlign: 'center',
      fontFamily: '-apple-system, system-ui',
      fontSize: 17,
      color: sugg,
      letterSpacing: -0.43,
      lineHeight: '22px'
    }
  }, w)))), /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      flexDirection: 'column',
      gap: 13,
      padding: '0 6.5px',
      width: '100%',
      boxSizing: 'border-box',
      position: 'relative'
    }
  }, row(['q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p']), row(['a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l'], 20), /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      gap: 14.25,
      alignItems: 'center'
    }
  }, key(icons.shift, {
    w: 45,
    k: 'shift'
  }), /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      gap: 6.5,
      flex: 1
    }
  }, ['z', 'x', 'c', 'v', 'b', 'n', 'm'].map(l => key(l, {
    flex: true,
    k: l
  }))), key(icons.del, {
    w: 45,
    k: 'del'
  })), /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      gap: 6,
      alignItems: 'center'
    }
  }, key('ABC', {
    w: 92.25,
    fs: 18,
    k: 'abc'
  }), key('', {
    flex: true,
    k: 'space'
  }), key(icons.ret, {
    w: 92.25,
    ret: true,
    k: 'ret'
  }))), /*#__PURE__*/React.createElement("div", {
    style: {
      height: 56,
      width: '100%',
      position: 'relative'
    }
  }));
}
Object.assign(window, {
  IOSDevice,
  IOSStatusBar,
  IOSNavBar,
  IOSGlassPill,
  IOSList,
  IOSListRow,
  IOSKeyboard
});
})(); } catch (e) { __ds_ns.__errors.push({ path: "ui_kits/student-panel/ios-frame.jsx", error: String((e && e.message) || e) }); }

// ui_kits/teacher-panel/InicioActual.jsx
try { (() => {
// InicioActual.jsx — faithful recreation of the CURRENT Inicio (from screenshots).
// Demonstrates the chromatic overload + red-wall problem. Read-only mock.

const ATENCION = ["Adriana Iraola", "Florencia Silva", "Gabriela Perez", "Isabel Da Luz Fernandez", "Lucia Cesar", "Luciana Perez", "Magali Avril Pighetti Becker", "Maria Cristina Garegnani", "Maria Julia Alberto", "Mariana Goñi", "Priscila Sanz", "Uma Gomez"];
const RECORD = [{
  n: "Maria Cristina Garegnani",
  e: "🔴 Vence HOY",
  c: "#dc2626",
  m: "$37.000"
}, {
  n: "Mirta Amarilla",
  e: "🔴 Vence HOY",
  c: "#dc2626",
  m: "$33.000"
}, {
  n: "Analia Marcela Menakian",
  e: "🟠 Atrasada 6 días",
  c: "#D97706",
  m: ""
}, {
  n: "Claudia Soriano",
  e: "🟠 Atrasada 6 días",
  c: "#D97706",
  m: ""
}, {
  n: "Julieta Cornador",
  e: "🟠 Atrasada 7 días",
  c: "#D97706",
  m: "$18.500"
}];
function initials(name) {
  const p = name.split(" ");
  return ((p[0] || "")[0] + ((p[1] || "")[0] || "")).toUpperCase();
}
function InicioActual() {
  return /*#__PURE__*/React.createElement("div", {
    className: "tp-root",
    style: {
      height: "100%"
    }
  }, /*#__PURE__*/React.createElement("div", {
    className: "tp-shell"
  }, /*#__PURE__*/React.createElement(ActualSidebar, null), /*#__PURE__*/React.createElement("main", {
    className: "tp-main",
    style: {
      overflow: "hidden"
    }
  }, /*#__PURE__*/React.createElement("div", {
    className: "tp-ptitle"
  }, "Inicio"), /*#__PURE__*/React.createElement("div", {
    className: "tp-card",
    style: {
      border: "2px solid var(--mod-funcional)",
      borderRadius: "var(--radius-lg)"
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      font: "600 11px var(--font-sans)",
      letterSpacing: ".06em",
      textTransform: "uppercase",
      color: "var(--mod-funcional)",
      marginBottom: ".6rem"
    }
  }, "\uD83C\uDF82 Pr\xF3ximos cumplea\xF1os"), /*#__PURE__*/React.createElement("div", {
    style: {
      display: "flex",
      alignItems: "center",
      gap: 10
    }
  }, /*#__PURE__*/React.createElement("div", {
    className: "tp-avatar",
    style: {
      width: 30,
      height: 30,
      fontSize: 11
    }
  }, "MA"), /*#__PURE__*/React.createElement("div", {
    style: {
      flex: 1,
      font: "13px var(--font-sans)"
    }
  }, "Micaela Aguilar"), /*#__PURE__*/React.createElement("div", {
    style: {
      font: "12px var(--font-sans)",
      color: "var(--mod-funcional)",
      fontWeight: 600
    }
  }, "Domingo"), /*#__PURE__*/React.createElement("button", {
    className: "tp-btn tp-btn-small",
    style: {
      borderColor: "var(--mod-funcional)",
      color: "var(--mod-funcional)"
    }
  }, "\uD83C\uDF89 Saludar"))), /*#__PURE__*/React.createElement("div", {
    style: {
      background: "#FCEBEB",
      border: "2px solid var(--status-danger)",
      borderRadius: "var(--radius-lg)",
      padding: "1.25rem",
      marginBottom: "1rem"
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      font: "600 11px var(--font-sans)",
      letterSpacing: ".06em",
      textTransform: "uppercase",
      color: "var(--status-danger)",
      marginBottom: ".2rem"
    }
  }, "\uD83D\uDD14 Requiere atenci\xF3n (14)"), /*#__PURE__*/React.createElement("div", {
    style: {
      font: "600 10px var(--font-sans)",
      letterSpacing: ".05em",
      textTransform: "uppercase",
      color: "var(--fg-muted)",
      marginBottom: ".5rem"
    }
  }, "3+ ausencias seguidas"), ATENCION.map((n, i) => /*#__PURE__*/React.createElement("div", {
    key: i,
    style: {
      display: "flex",
      alignItems: "center",
      gap: 10,
      padding: "6px 0",
      borderBottom: "1px solid rgba(163,45,45,.12)"
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      width: 28,
      height: 28,
      borderRadius: "50%",
      background: "#A32D2D",
      color: "#fff",
      display: "flex",
      alignItems: "center",
      justifyContent: "center",
      font: "600 11px var(--font-sans)",
      flexShrink: 0
    }
  }, initials(n)), /*#__PURE__*/React.createElement("div", {
    style: {
      flex: 1,
      font: "500 13px var(--font-sans)"
    }
  }, n), /*#__PURE__*/React.createElement("div", {
    style: {
      font: "11px var(--font-sans)",
      color: "var(--status-danger)",
      fontStyle: "italic"
    }
  }, "Riesgo abandono")))), /*#__PURE__*/React.createElement("div", {
    style: {
      background: "#FEFAEC",
      border: "2px solid var(--mod-funcional)",
      borderRadius: "var(--radius-lg)",
      padding: "1.25rem",
      marginBottom: "1rem"
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      display: "flex",
      alignItems: "center",
      justifyContent: "space-between",
      marginBottom: ".5rem"
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      font: "600 11px var(--font-sans)",
      letterSpacing: ".06em",
      textTransform: "uppercase",
      color: "var(--mod-funcional)"
    }
  }, "\uD83D\uDD14 Recordatorios \u2014 7 alumnas"), /*#__PURE__*/React.createElement("button", {
    className: "tp-btn tp-btn-small"
  }, "\uD83D\uDCF2 Recordar a todas")), RECORD.map((r, i) => /*#__PURE__*/React.createElement("div", {
    key: i,
    style: {
      display: "flex",
      alignItems: "center",
      gap: 10,
      padding: "7px 0",
      borderBottom: "1px solid rgba(0,0,0,.06)"
    }
  }, /*#__PURE__*/React.createElement("div", {
    className: "tp-avatar",
    style: {
      width: 30,
      height: 30,
      fontSize: 11
    }
  }, initials(r.n)), /*#__PURE__*/React.createElement("div", {
    style: {
      flex: 1
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      font: "500 13px var(--font-sans)"
    }
  }, r.n), /*#__PURE__*/React.createElement("div", {
    style: {
      font: "11px var(--font-sans)",
      color: r.c
    }
  }, r.e)), r.m && /*#__PURE__*/React.createElement("div", {
    style: {
      font: "600 12px var(--font-sans)"
    }
  }, r.m), /*#__PURE__*/React.createElement("span", {
    style: {
      padding: "4px 10px",
      border: "1px solid var(--mod-mat)",
      borderRadius: "var(--radius)",
      background: "var(--mod-mat-tint)",
      color: "var(--mod-mat)",
      font: "500 11px var(--font-sans)",
      whiteSpace: "nowrap"
    }
  }, "\uD83D\uDCAC WA")))), /*#__PURE__*/React.createElement("div", {
    style: {
      display: "grid",
      gridTemplateColumns: "repeat(4,1fr)",
      gap: 10,
      marginBottom: "1rem"
    }
  }, /*#__PURE__*/React.createElement("div", {
    className: "tp-metric"
  }, /*#__PURE__*/React.createElement("div", {
    className: "tp-metric-label"
  }, "Alumnas activas"), /*#__PURE__*/React.createElement("div", {
    className: "tp-metric-value violet"
  }, "54")), /*#__PURE__*/React.createElement("div", {
    className: "tp-metric"
  }, /*#__PURE__*/React.createElement("div", {
    className: "tp-metric-label"
  }, "Pagaron Jun 2026"), /*#__PURE__*/React.createElement("div", {
    className: "tp-metric-value violet"
  }, "29")), /*#__PURE__*/React.createElement("div", {
    className: "tp-metric"
  }, /*#__PURE__*/React.createElement("div", {
    className: "tp-metric-label"
  }, "Pendientes"), /*#__PURE__*/React.createElement("div", {
    className: "tp-metric-value warning"
  }, "25")), /*#__PURE__*/React.createElement("div", {
    className: "tp-metric"
  }, /*#__PURE__*/React.createElement("div", {
    className: "tp-metric-label"
  }, "Recaudado Jun 2026"), /*#__PURE__*/React.createElement("div", {
    className: "tp-metric-value"
  }, "$1.079.000"))), /*#__PURE__*/React.createElement("button", {
    style: {
      width: "100%",
      padding: "14px",
      background: "#2563EB",
      color: "#fff",
      border: "none",
      borderRadius: "var(--radius)",
      font: "600 14px var(--font-sans)",
      marginBottom: "1rem",
      cursor: "pointer"
    }
  }, "\uD83D\uDCCA Ver informe mensual"), /*#__PURE__*/React.createElement("div", {
    style: {
      background: "var(--mod-mat-tint)",
      borderLeft: "4px solid var(--mod-mat)",
      borderRadius: "var(--radius-lg)",
      padding: "1rem",
      display: "flex",
      alignItems: "center",
      gap: 10
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      fontSize: 22
    }
  }, "\u2705"), /*#__PURE__*/React.createElement("div", null, /*#__PURE__*/React.createElement("div", {
    style: {
      font: "600 13px var(--font-sans)",
      color: "var(--mod-mat)"
    }
  }, "Notificaciones activas"), /*#__PURE__*/React.createElement("div", {
    style: {
      font: "12px var(--font-sans)",
      color: "var(--fg-muted)"
    }
  }, "Vas a recibir avisos cuando una alumna reporte un pago"))))));
}
function ActualSidebar() {
  const items = [{
    sep: "Principal"
  }, {
    ico: "🏠",
    l: "Inicio",
    active: true
  }, {
    ico: "👤",
    l: "Alumnas"
  }, {
    sep: "Clases"
  }, {
    ico: "📅",
    l: "Horarios"
  }, {
    ico: "📝",
    l: "Planificar"
  }, {
    ico: "📚",
    l: "Historial"
  }, {
    ico: "📋",
    l: "Planes"
  }, {
    sep: "Gestión"
  }, {
    ico: "💰",
    l: "Pagos"
  }, {
    ico: "📗",
    l: "Biblioteca"
  }, {
    ico: "⚙",
    l: "Tarifas"
  }, {
    ico: "💬",
    l: "Mensajes WA"
  }];
  return /*#__PURE__*/React.createElement("aside", {
    className: "tp-sidebar"
  }, /*#__PURE__*/React.createElement("div", {
    className: "tp-sidebar-logo"
  }, /*#__PURE__*/React.createElement("div", {
    className: "tp-sidebar-logo-name"
  }, /*#__PURE__*/React.createElement("img", {
    src: "../../assets/logo-triskel.png",
    alt: ""
  }), "Triskel Academy"), /*#__PURE__*/React.createElement("div", {
    className: "tp-sidebar-logo-sub"
  }, "Panel de gesti\xF3n")), /*#__PURE__*/React.createElement("div", {
    className: "tp-sidebar-search"
  }, /*#__PURE__*/React.createElement("input", {
    placeholder: "\uD83D\uDD0D Buscar alumna..."
  })), /*#__PURE__*/React.createElement("nav", {
    className: "tp-snav"
  }, items.map((it, i) => it.sep ? /*#__PURE__*/React.createElement("div", {
    key: i,
    className: "sep"
  }, it.sep) : /*#__PURE__*/React.createElement("a", {
    key: i,
    className: it.active ? "active" : "",
    href: "#",
    onClick: e => e.preventDefault()
  }, /*#__PURE__*/React.createElement("span", null, it.ico), /*#__PURE__*/React.createElement("span", {
    style: {
      flex: 1
    }
  }, it.l)))), /*#__PURE__*/React.createElement("div", {
    className: "tp-sbottom"
  }, /*#__PURE__*/React.createElement("button", null, "\uD83C\uDF19 Modo oscuro"), /*#__PURE__*/React.createElement("button", {
    style: {
      marginTop: 2
    }
  }, "\u21A9 Salir")));
}
Object.assign(window, {
  InicioActual
});
})(); } catch (e) { __ds_ns.__errors.push({ path: "ui_kits/teacher-panel/InicioActual.jsx", error: String((e && e.message) || e) }); }

// ui_kits/teacher-panel/InicioPropuesta.jsx
try { (() => {
// InicioPropuesta.jsx — improved Inicio applying fixes #1-#4.
// #1 chromatic discipline (neutral headers, white cards + left accent)
// #2 "requiere atención" = white card, label once, violet avatars, actionable rows, top-N
// #3 violet secondary CTA (not full-width saturated blue)
// #4 Esfero in safe teal — red reserved for negative state only

const ATENCION_P = [{
  n: "Adriana Iraola",
  d: "5 ausencias seguidas · última clase 26 may"
}, {
  n: "Florencia Silva",
  d: "4 ausencias seguidas · última clase 28 may"
}, {
  n: "Gabriela Perez",
  d: "3 ausencias seguidas · última clase 30 may"
}, {
  n: "Isabel Da Luz Fernandez",
  d: "3 ausencias seguidas · última clase 30 may"
}];
const RECORD_P = [{
  n: "Maria Cristina Garegnani",
  e: "Vence hoy",
  urgent: true,
  m: "$37.000"
}, {
  n: "Mirta Amarilla",
  e: "Vence hoy",
  urgent: true,
  m: "$33.000"
}, {
  n: "Analia Marcela Menakian",
  e: "Atrasada 6 días",
  urgent: false,
  m: ""
}, {
  n: "Julieta Cornador",
  e: "Atrasada 7 días",
  urgent: false,
  m: "$18.500"
}];
function inits(name) {
  const p = name.split(" ");
  return ((p[0] || "")[0] + ((p[1] || "")[0] || "")).toUpperCase();
}

// Neutral, consistent section header — color carries meaning, not decoration.
function SectionHead({
  children,
  count,
  action
}) {
  return /*#__PURE__*/React.createElement("div", {
    style: {
      display: "flex",
      alignItems: "center",
      justifyContent: "space-between",
      marginBottom: ".75rem"
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      display: "flex",
      alignItems: "baseline",
      gap: 8
    }
  }, /*#__PURE__*/React.createElement("span", {
    style: {
      font: "600 11px var(--font-sans)",
      letterSpacing: ".06em",
      textTransform: "uppercase",
      color: "var(--fg-muted)"
    }
  }, children), count != null && /*#__PURE__*/React.createElement("span", {
    style: {
      font: "600 11px var(--font-sans)",
      color: "var(--fg-faint)"
    }
  }, count)), action);
}
function InicioPropuesta() {
  return /*#__PURE__*/React.createElement("div", {
    className: "tp-root",
    style: {
      height: "100%"
    }
  }, /*#__PURE__*/React.createElement("div", {
    className: "tp-shell"
  }, /*#__PURE__*/React.createElement(PropuestaSidebar, null), /*#__PURE__*/React.createElement("main", {
    className: "tp-main",
    style: {
      overflow: "hidden"
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      display: "flex",
      alignItems: "flex-end",
      justifyContent: "space-between",
      marginBottom: "1.5rem"
    }
  }, /*#__PURE__*/React.createElement("div", {
    className: "tp-ptitle",
    style: {
      margin: 0
    }
  }, "Inicio"), /*#__PURE__*/React.createElement("button", {
    className: "tp-btn",
    style: {
      borderColor: "var(--brand-violet)",
      color: "var(--brand-violet)",
      fontWeight: 500
    }
  }, "Ver informe mensual \u2192")), /*#__PURE__*/React.createElement("div", {
    style: {
      display: "grid",
      gridTemplateColumns: "repeat(4,1fr)",
      gap: 10,
      marginBottom: "1.5rem"
    }
  }, /*#__PURE__*/React.createElement("div", {
    className: "tp-metric"
  }, /*#__PURE__*/React.createElement("div", {
    className: "tp-metric-label"
  }, "Alumnas activas"), /*#__PURE__*/React.createElement("div", {
    className: "tp-metric-value violet"
  }, "54")), /*#__PURE__*/React.createElement("div", {
    className: "tp-metric"
  }, /*#__PURE__*/React.createElement("div", {
    className: "tp-metric-label"
  }, "Pagaron Jun 2026"), /*#__PURE__*/React.createElement("div", {
    className: "tp-metric-value violet"
  }, "29")), /*#__PURE__*/React.createElement("div", {
    className: "tp-metric"
  }, /*#__PURE__*/React.createElement("div", {
    className: "tp-metric-label"
  }, "Pendientes"), /*#__PURE__*/React.createElement("div", {
    className: "tp-metric-value warning"
  }, "25")), /*#__PURE__*/React.createElement("div", {
    className: "tp-metric"
  }, /*#__PURE__*/React.createElement("div", {
    className: "tp-metric-label"
  }, "Recaudado Jun 2026"), /*#__PURE__*/React.createElement("div", {
    className: "tp-metric-value"
  }, "$1.079.000"))), /*#__PURE__*/React.createElement("div", {
    className: "tp-card",
    style: {
      borderLeft: "3px solid var(--status-danger)"
    }
  }, /*#__PURE__*/React.createElement(SectionHead, {
    count: "14",
    action: /*#__PURE__*/React.createElement("a", {
      href: "#",
      onClick: e => e.preventDefault(),
      style: {
        font: "12px var(--font-sans)",
        color: "var(--brand-violet)",
        textDecoration: "none"
      }
    }, "Ver las 14 \u2192")
  }, "Requiere atenci\xF3n"), /*#__PURE__*/React.createElement("div", {
    style: {
      font: "12px var(--font-sans)",
      color: "var(--fg-muted)",
      marginTop: "-.5rem",
      marginBottom: ".75rem"
    }
  }, "Riesgo de abandono \xB7 3+ ausencias seguidas"), ATENCION_P.map((a, i) => /*#__PURE__*/React.createElement("div", {
    key: i,
    style: {
      display: "flex",
      alignItems: "center",
      gap: 10,
      padding: "8px 0",
      borderBottom: i < ATENCION_P.length - 1 ? "1px solid var(--border)" : "none"
    }
  }, /*#__PURE__*/React.createElement("div", {
    className: "tp-avatar",
    style: {
      width: 32,
      height: 32,
      fontSize: 12
    }
  }, inits(a.n)), /*#__PURE__*/React.createElement("div", {
    style: {
      flex: 1,
      minWidth: 0
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      font: "500 13px var(--font-sans)"
    }
  }, a.n), /*#__PURE__*/React.createElement("div", {
    style: {
      font: "11px var(--font-sans)",
      color: "var(--fg-muted)"
    }
  }, a.d)), /*#__PURE__*/React.createElement("span", {
    style: {
      padding: "4px 10px",
      border: "1px solid var(--mod-mat)",
      borderRadius: "var(--radius)",
      background: "var(--mod-mat-tint)",
      color: "var(--mod-mat)",
      font: "500 11px var(--font-sans)",
      whiteSpace: "nowrap"
    }
  }, "\uD83D\uDCAC WA")))), /*#__PURE__*/React.createElement("div", {
    className: "tp-card",
    style: {
      borderLeft: "3px solid var(--status-warning)"
    }
  }, /*#__PURE__*/React.createElement(SectionHead, {
    count: "7",
    action: /*#__PURE__*/React.createElement("button", {
      className: "tp-btn tp-btn-small"
    }, "Recordar a todas")
  }, "Recordatorios de pago"), RECORD_P.map((r, i) => /*#__PURE__*/React.createElement("div", {
    key: i,
    style: {
      display: "flex",
      alignItems: "center",
      gap: 10,
      padding: "8px 0",
      borderBottom: i < RECORD_P.length - 1 ? "1px solid var(--border)" : "none"
    }
  }, /*#__PURE__*/React.createElement("div", {
    className: "tp-avatar",
    style: {
      width: 32,
      height: 32,
      fontSize: 12
    }
  }, inits(r.n)), /*#__PURE__*/React.createElement("div", {
    style: {
      flex: 1,
      minWidth: 0
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      font: "500 13px var(--font-sans)"
    }
  }, r.n), /*#__PURE__*/React.createElement("div", {
    style: {
      font: "11px var(--font-sans)",
      color: r.urgent ? "var(--status-danger)" : "var(--fg-muted)"
    }
  }, r.urgent && /*#__PURE__*/React.createElement("span", {
    style: {
      display: "inline-block",
      width: 7,
      height: 7,
      borderRadius: "50%",
      background: "var(--status-danger)",
      marginRight: 5,
      verticalAlign: "middle"
    }
  }), r.e)), r.m && /*#__PURE__*/React.createElement("div", {
    style: {
      font: "600 12px var(--font-sans)"
    }
  }, r.m), /*#__PURE__*/React.createElement("span", {
    style: {
      padding: "4px 10px",
      border: "1px solid var(--mod-mat)",
      borderRadius: "var(--radius)",
      background: "var(--mod-mat-tint)",
      color: "var(--mod-mat)",
      font: "500 11px var(--font-sans)",
      whiteSpace: "nowrap"
    }
  }, "\uD83D\uDCAC WA")))), /*#__PURE__*/React.createElement("div", {
    style: {
      display: "grid",
      gridTemplateColumns: "1fr 1fr",
      gap: "1rem",
      marginBottom: "1rem"
    }
  }, /*#__PURE__*/React.createElement("div", {
    className: "tp-card",
    style: {
      marginBottom: 0
    }
  }, /*#__PURE__*/React.createElement(SectionHead, null, "Pr\xF3ximos cumplea\xF1os"), /*#__PURE__*/React.createElement("div", {
    style: {
      display: "flex",
      alignItems: "center",
      gap: 10
    }
  }, /*#__PURE__*/React.createElement("div", {
    className: "tp-avatar",
    style: {
      width: 30,
      height: 30,
      fontSize: 11
    }
  }, "MA"), /*#__PURE__*/React.createElement("div", {
    style: {
      flex: 1,
      font: "13px var(--font-sans)"
    }
  }, "Micaela Aguilar"), /*#__PURE__*/React.createElement("div", {
    style: {
      font: "12px var(--font-sans)",
      color: "var(--fg-muted)"
    }
  }, "Domingo"), /*#__PURE__*/React.createElement("button", {
    className: "tp-btn tp-btn-small"
  }, "Saludar"))), /*#__PURE__*/React.createElement("div", {
    className: "tp-card",
    style: {
      marginBottom: 0
    }
  }, /*#__PURE__*/React.createElement(SectionHead, null, "Alumnas por modalidad"), /*#__PURE__*/React.createElement("div", {
    style: {
      display: "flex",
      flexDirection: "column",
      gap: 8
    }
  }, /*#__PURE__*/React.createElement(ModRow, {
    color: "var(--mod-reformer)",
    bg: "var(--mod-reformer-tint)",
    label: "Reformer",
    n: 28
  }), /*#__PURE__*/React.createElement(ModRow, {
    color: "var(--mod-mat)",
    bg: "var(--mod-mat-tint)",
    label: "Mat",
    n: 14
  }), /*#__PURE__*/React.createElement(ModRow, {
    color: "var(--mod-funcional)",
    bg: "var(--mod-funcional-tint)",
    label: "Funcional",
    n: 13
  }), /*#__PURE__*/React.createElement(ModRow, {
    color: "#0D9488",
    bg: "#CCFBF1",
    label: "Esfero",
    n: 6
  })))), /*#__PURE__*/React.createElement("div", {
    style: {
      display: "flex",
      alignItems: "center",
      gap: 8,
      font: "12px var(--font-sans)",
      color: "var(--fg-muted)",
      padding: "4px 2px"
    }
  }, /*#__PURE__*/React.createElement("span", {
    style: {
      color: "var(--mod-mat)"
    }
  }, "\u2713"), "Notificaciones activas \u2014 vas a recibir avisos cuando una alumna reporte un pago."))));
}
function ModRow({
  color,
  bg,
  label,
  n
}) {
  return /*#__PURE__*/React.createElement("div", {
    style: {
      display: "flex",
      alignItems: "center",
      justifyContent: "space-between"
    }
  }, /*#__PURE__*/React.createElement("span", {
    className: "tp-badge",
    style: {
      background: bg,
      color: color
    }
  }, label), /*#__PURE__*/React.createElement("strong", {
    style: {
      font: "600 14px var(--font-sans)"
    }
  }, n));
}
function PropuestaSidebar() {
  const items = [{
    sep: "Principal"
  }, {
    ico: "🏠",
    l: "Inicio",
    active: true
  }, {
    ico: "👤",
    l: "Alumnas"
  }, {
    sep: "Clases"
  }, {
    ico: "📅",
    l: "Horarios"
  }, {
    ico: "📝",
    l: "Planificar"
  }, {
    ico: "📚",
    l: "Historial"
  }, {
    ico: "📋",
    l: "Planes"
  }, {
    sep: "Gestión"
  }, {
    ico: "💰",
    l: "Pagos"
  }, {
    ico: "📗",
    l: "Biblioteca"
  }, {
    ico: "⚙",
    l: "Tarifas"
  }, {
    ico: "💬",
    l: "Mensajes WA"
  }];
  return /*#__PURE__*/React.createElement("aside", {
    className: "tp-sidebar"
  }, /*#__PURE__*/React.createElement("div", {
    className: "tp-sidebar-logo"
  }, /*#__PURE__*/React.createElement("div", {
    className: "tp-sidebar-logo-name"
  }, /*#__PURE__*/React.createElement("img", {
    src: "../../assets/logo-triskel.png",
    alt: ""
  }), "Triskel Academy"), /*#__PURE__*/React.createElement("div", {
    className: "tp-sidebar-logo-sub"
  }, "Panel de gesti\xF3n")), /*#__PURE__*/React.createElement("div", {
    className: "tp-sidebar-search"
  }, /*#__PURE__*/React.createElement("input", {
    placeholder: "\uD83D\uDD0D Buscar alumna..."
  })), /*#__PURE__*/React.createElement("nav", {
    className: "tp-snav"
  }, items.map((it, i) => it.sep ? /*#__PURE__*/React.createElement("div", {
    key: i,
    className: "sep"
  }, it.sep) : /*#__PURE__*/React.createElement("a", {
    key: i,
    className: it.active ? "active" : "",
    href: "#",
    onClick: e => e.preventDefault()
  }, /*#__PURE__*/React.createElement("span", null, it.ico), /*#__PURE__*/React.createElement("span", {
    style: {
      flex: 1
    }
  }, it.l)))), /*#__PURE__*/React.createElement("div", {
    className: "tp-sbottom"
  }, /*#__PURE__*/React.createElement("button", null, "\uD83C\uDF19 Modo oscuro"), /*#__PURE__*/React.createElement("button", {
    style: {
      marginTop: 2
    }
  }, "\u21A9 Salir")));
}
Object.assign(window, {
  InicioPropuesta
});
})(); } catch (e) { __ds_ns.__errors.push({ path: "ui_kits/teacher-panel/InicioPropuesta.jsx", error: String((e && e.message) || e) }); }

// ui_kits/teacher-panel/TeacherPrimitives.jsx
try { (() => {
// Primitives.jsx — teacher panel building blocks.

const TPBadge = ({
  modalidad,
  children
}) => /*#__PURE__*/React.createElement("span", {
  className: `tp-badge tp-badge-${modalidad}`
}, children || window.TP_MOD_LABEL[modalidad] || modalidad);
const TPCard = ({
  children,
  title,
  accent,
  style
}) => {
  const cls = "tp-card" + (accent ? ` tp-card-accent-${accent}` : "");
  return /*#__PURE__*/React.createElement("div", {
    className: cls,
    style: style
  }, title ? /*#__PURE__*/React.createElement("div", {
    className: "tp-ctitle"
  }, title) : null, children);
};
const TPMetric = ({
  label,
  value,
  tone
}) => /*#__PURE__*/React.createElement("div", {
  className: "tp-metric"
}, /*#__PURE__*/React.createElement("div", {
  className: "tp-metric-label"
}, label), /*#__PURE__*/React.createElement("div", {
  className: "tp-metric-value" + (tone ? " " + tone : "")
}, value));
const TPSidebar = ({
  current,
  onNav,
  onSearch,
  onOpenTarifas,
  onOpenMensajes,
  onToggleTheme,
  onLogout,
  badgePagos
}) => {
  const items = [{
    sep: "Principal"
  }, {
    id: "inicio",
    ico: "🏠",
    lbl: "Inicio"
  }, {
    id: "alumnas",
    ico: "👤",
    lbl: "Alumnas"
  }, {
    sep: "Clases"
  }, {
    id: "horarios",
    ico: "📅",
    lbl: "Horarios"
  }, {
    id: "clases",
    ico: "📝",
    lbl: "Planificar"
  }, {
    id: "historial",
    ico: "📚",
    lbl: "Historial"
  }, {
    sep: "Gestión"
  }, {
    id: "pagos",
    ico: "💰",
    lbl: "Pagos",
    badge: badgePagos
  }, {
    id: "tarifas",
    ico: "⚙",
    lbl: "Tarifas",
    action: onOpenTarifas
  }, {
    id: "mensajes",
    ico: "💬",
    lbl: "Mensajes WA",
    action: onOpenMensajes
  }];
  return /*#__PURE__*/React.createElement("aside", {
    className: "tp-sidebar"
  }, /*#__PURE__*/React.createElement("div", {
    className: "tp-sidebar-logo"
  }, /*#__PURE__*/React.createElement("div", {
    className: "tp-sidebar-logo-name"
  }, /*#__PURE__*/React.createElement("img", {
    src: "../../assets/logo-triskel.png",
    alt: ""
  }), "Triskel Academy"), /*#__PURE__*/React.createElement("div", {
    className: "tp-sidebar-logo-sub"
  }, "Panel de gesti\xF3n")), /*#__PURE__*/React.createElement("div", {
    className: "tp-sidebar-search"
  }, /*#__PURE__*/React.createElement("input", {
    placeholder: "\uD83D\uDD0D Buscar alumna...",
    onChange: e => onSearch && onSearch(e.target.value)
  })), /*#__PURE__*/React.createElement("nav", {
    className: "tp-snav"
  }, items.map((it, idx) => it.sep ? /*#__PURE__*/React.createElement("div", {
    key: "sep" + idx,
    className: "sep"
  }, it.sep) : /*#__PURE__*/React.createElement("a", {
    key: it.id,
    className: current === it.id ? "active" : "",
    onClick: e => {
      e.preventDefault();
      it.action ? it.action() : onNav(it.id);
    },
    href: "#"
  }, /*#__PURE__*/React.createElement("span", null, it.ico), /*#__PURE__*/React.createElement("span", {
    style: {
      flex: 1
    }
  }, it.lbl), it.badge ? /*#__PURE__*/React.createElement("span", {
    style: {
      background: "var(--status-danger)",
      color: "#fff",
      font: "700 10px var(--font-sans)",
      borderRadius: "99px",
      padding: "1px 6px"
    }
  }, it.badge) : null))), /*#__PURE__*/React.createElement("div", {
    className: "tp-sbottom"
  }, /*#__PURE__*/React.createElement("button", {
    onClick: onToggleTheme
  }, "\uD83C\uDF19 Modo oscuro"), /*#__PURE__*/React.createElement("button", {
    onClick: onLogout,
    style: {
      marginTop: 2
    }
  }, "\u21A9 Salir")));
};
const TPAlumnaRow = ({
  alumna,
  inscs,
  pagoStatus,
  onEdit,
  onOpen
}) => /*#__PURE__*/React.createElement("div", {
  className: "tp-arow"
}, /*#__PURE__*/React.createElement("div", {
  className: "tp-avatar"
}, window.TP_alumnaInits(alumna.nombre, alumna.apellido)), /*#__PURE__*/React.createElement("div", {
  style: {
    flex: 1,
    minWidth: 0
  }
}, /*#__PURE__*/React.createElement("div", {
  className: "tp-aname tp-aname-link",
  onClick: () => onOpen(alumna.id)
}, alumna.nombre, " ", alumna.apellido || ""), /*#__PURE__*/React.createElement("div", {
  className: "tp-asub"
}, inscs.map((i, idx) => i.horario ? /*#__PURE__*/React.createElement("span", {
  key: idx,
  style: {
    display: "inline-flex",
    alignItems: "center",
    gap: 3
  }
}, /*#__PURE__*/React.createElement(TPBadge, {
  modalidad: i.horario.modalidad
}), /*#__PURE__*/React.createElement("span", {
  style: {
    font: "10px var(--font-sans)",
    color: "var(--fg-muted)"
  }
}, window.TP_DIA_LABEL[i.horario.dia], " ", i.horario.hora_inicio)) : null), alumna.tel && /*#__PURE__*/React.createElement("a", {
  href: "https://wa.me/" + alumna.tel,
  target: "_blank",
  style: {
    font: "11px var(--font-sans)",
    color: "var(--mod-mat)",
    textDecoration: "none"
  }
}, "\uD83D\uDCAC WA"))), inscs.length > 0 && pagoStatus && /*#__PURE__*/React.createElement("span", {
  className: "tp-pago-pill " + pagoStatus.kind
}, pagoStatus.label), /*#__PURE__*/React.createElement("div", {
  style: {
    display: "flex",
    gap: 6,
    flexWrap: "wrap"
  }
}, /*#__PURE__*/React.createElement("button", {
  className: "tp-btn tp-btn-small",
  onClick: () => onEdit(alumna.id)
}, "Editar"), alumna.estado === "activa" && /*#__PURE__*/React.createElement("button", {
  className: "tp-btn tp-btn-small"
}, "\u23F8 Pausar"), alumna.estado === "pausada" && /*#__PURE__*/React.createElement("button", {
  className: "tp-btn tp-btn-small tp-btn-primary"
}, "\u25B6 Reactivar")));
Object.assign(window, {
  TPBadge,
  TPCard,
  TPMetric,
  TPSidebar,
  TPAlumnaRow
});
})(); } catch (e) { __ds_ns.__errors.push({ path: "ui_kits/teacher-panel/TeacherPrimitives.jsx", error: String((e && e.message) || e) }); }

// ui_kits/teacher-panel/TeacherScreens.jsx
try { (() => {
// Screens.jsx — teacher panel screens
const {
  useState,
  useMemo
} = React;

// ── Login ───────────────────────────────────────────────────
const TPLogin = ({
  onLogin
}) => {
  const [email, setEmail] = useState("amira@triskel.com");
  const [pwd, setPwd] = useState("••••••••");
  return /*#__PURE__*/React.createElement("div", {
    className: "tp-login"
  }, /*#__PURE__*/React.createElement("div", {
    className: "tp-login-card"
  }, /*#__PURE__*/React.createElement("div", {
    className: "tp-logo"
  }, /*#__PURE__*/React.createElement("img", {
    src: "../../assets/logo-triskel.png",
    alt: ""
  })), /*#__PURE__*/React.createElement("h2", null, "Triskel Academy"), /*#__PURE__*/React.createElement("p", null, "Panel de gesti\xF3n"), /*#__PURE__*/React.createElement("input", {
    className: "tp-login-input",
    type: "email",
    value: email,
    onChange: e => setEmail(e.target.value)
  }), /*#__PURE__*/React.createElement("input", {
    className: "tp-login-input",
    type: "password",
    value: pwd,
    onChange: e => setPwd(e.target.value),
    onKeyDown: e => e.key === 'Enter' && onLogin()
  }), /*#__PURE__*/React.createElement("button", {
    className: "tp-login-btn",
    onClick: onLogin
  }, "Ingresar")));
};

// ── Inicio ──────────────────────────────────────────────────
const TPInicio = ({
  db
}) => {
  const mes = db.mesActual;
  const activas = db.alumnas.filter(a => a.estado === "activa");
  const pagosMes = db.pagos.filter(p => p.mes === mes && p.pagado);
  const pagaron = new Set(pagosMes.map(p => p.alumna_id)).size;
  const pendientes = activas.length - pagaron;
  const recaudado = pagosMes.reduce((s, p) => s + (p.monto || 0), 0);
  const modCount = {
    mat: new Set(),
    reformer: new Set(),
    funcional: new Set()
  };
  db.inscripciones.forEach(i => {
    const h = db.horarios.find(x => x.id === i.horario_id);
    if (h) modCount[h.modalidad]?.add(i.alumna_id);
  });

  // Recordatorios: alumnas activas con cuota vencida o por vencer.
  const diaHoy = new Date().getDate();
  const recordatorios = activas.filter(a => a.dia_pago && !pagosMes.find(p => p.alumna_id === a.id)).map(a => {
    const diff = diaHoy - a.dia_pago;
    const monto = window.TP_inscByAlumna(db, a.id).reduce((s, i) => s + (i.precio || 0), 0);
    if (diff === 0) return {
      ...a,
      monto,
      tipo: "hoy",
      label: "🔴 Vence HOY",
      color: "var(--status-danger)"
    };
    if (diff > 0) return {
      ...a,
      monto,
      tipo: "atrasada",
      label: `🟠 Atrasada ${diff} día${diff !== 1 ? 's' : ''}`,
      color: "var(--mod-funcional)"
    };
    if (diff >= -3) return {
      ...a,
      monto,
      tipo: "proxima",
      label: `🟡 Vence en ${-diff} día${-diff !== 1 ? 's' : ''}`,
      color: "var(--fg-muted)"
    };
    return null;
  }).filter(Boolean);
  return /*#__PURE__*/React.createElement(React.Fragment, null, /*#__PURE__*/React.createElement("div", {
    className: "tp-ptitle"
  }, "Inicio"), recordatorios.length > 0 && /*#__PURE__*/React.createElement(TPCard, {
    accent: "funcional",
    style: {
      borderLeft: "3px solid var(--mod-funcional)",
      marginBottom: "1.25rem"
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      display: "flex",
      alignItems: "center",
      justifyContent: "space-between",
      marginBottom: ".5rem"
    }
  }, /*#__PURE__*/React.createElement("div", {
    className: "tp-ctitle",
    style: {
      margin: 0,
      color: "var(--mod-funcional)"
    }
  }, "\u23F0 Recordatorios \u2014 ", recordatorios.length, " alumna", recordatorios.length !== 1 ? 's' : ''), /*#__PURE__*/React.createElement("button", {
    className: "tp-btn tp-btn-small"
  }, "\uD83D\uDCF2 Recordar a todas")), recordatorios.map(r => /*#__PURE__*/React.createElement("div", {
    className: "tp-rem-row",
    key: r.id
  }, /*#__PURE__*/React.createElement("div", {
    className: "tp-avatar",
    style: {
      width: 30,
      height: 30,
      fontSize: 11
    }
  }, window.TP_alumnaInits(r.nombre, r.apellido)), /*#__PURE__*/React.createElement("div", {
    style: {
      flex: 1
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      font: "500 13px var(--font-sans)"
    }
  }, r.nombre, " ", r.apellido), /*#__PURE__*/React.createElement("div", {
    style: {
      font: "11px var(--font-sans)",
      color: r.color
    }
  }, r.label)), r.monto > 0 && /*#__PURE__*/React.createElement("div", {
    style: {
      font: "600 12px var(--font-sans)"
    }
  }, window.TP_money(r.monto)), /*#__PURE__*/React.createElement("a", {
    className: "tp-wa-btn",
    href: "https://wa.me/" + r.tel,
    target: "_blank"
  }, "\uD83D\uDCAC WA")))), /*#__PURE__*/React.createElement("div", {
    style: {
      display: "grid",
      gridTemplateColumns: "repeat(4,1fr)",
      gap: 10,
      marginBottom: "1.25rem"
    }
  }, /*#__PURE__*/React.createElement(TPMetric, {
    label: "Alumnas activas",
    value: activas.length,
    tone: "violet"
  }), /*#__PURE__*/React.createElement(TPMetric, {
    label: `Pagaron ${window.TP_mesLabel(mes)}`,
    value: pagaron,
    tone: "violet"
  }), /*#__PURE__*/React.createElement(TPMetric, {
    label: "Pendientes",
    value: pendientes,
    tone: "warning"
  }), /*#__PURE__*/React.createElement(TPMetric, {
    label: `Recaudado ${window.TP_mesLabel(mes)}`,
    value: window.TP_money(recaudado)
  })), /*#__PURE__*/React.createElement("div", {
    style: {
      display: "grid",
      gridTemplateColumns: "1fr 1fr",
      gap: "1rem",
      marginBottom: "1rem"
    }
  }, /*#__PURE__*/React.createElement(TPCard, {
    title: "Alumnas por modalidad"
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      display: "flex",
      flexDirection: "column",
      gap: 8
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      display: "flex",
      alignItems: "center",
      justifyContent: "space-between"
    }
  }, /*#__PURE__*/React.createElement(TPBadge, {
    modalidad: "reformer"
  }), /*#__PURE__*/React.createElement("strong", null, modCount.reformer.size)), /*#__PURE__*/React.createElement("div", {
    style: {
      display: "flex",
      alignItems: "center",
      justifyContent: "space-between"
    }
  }, /*#__PURE__*/React.createElement(TPBadge, {
    modalidad: "mat"
  }), /*#__PURE__*/React.createElement("strong", null, modCount.mat.size)), /*#__PURE__*/React.createElement("div", {
    style: {
      display: "flex",
      alignItems: "center",
      justifyContent: "space-between"
    }
  }, /*#__PURE__*/React.createElement(TPBadge, {
    modalidad: "funcional"
  }), /*#__PURE__*/React.createElement("strong", null, modCount.funcional.size)))), /*#__PURE__*/React.createElement(TPCard, {
    title: "\xDAltimas clases"
  }, db.clases.length ? db.clases.map(c => {
    const h = db.horarios.find(x => x.id === c.horario_id);
    return /*#__PURE__*/React.createElement("div", {
      key: c.id,
      style: {
        display: "flex",
        alignItems: "center",
        gap: 8,
        padding: "5px 0",
        borderBottom: "1px solid var(--border)"
      }
    }, /*#__PURE__*/React.createElement("div", {
      style: {
        flex: 1,
        font: "13px var(--font-sans)"
      }
    }, c.fecha, " ", h && /*#__PURE__*/React.createElement(TPBadge, {
      modalidad: h.modalidad
    })), /*#__PURE__*/React.createElement("div", {
      style: {
        font: "11px var(--font-sans)",
        color: "var(--fg-muted)"
      }
    }, c.ejercicios.length, " ejs."));
  }) : /*#__PURE__*/React.createElement("div", {
    style: {
      font: "13px var(--font-sans)",
      color: "var(--fg-muted)"
    }
  }, "Sin clases registradas a\xFAn."))), /*#__PURE__*/React.createElement(TPCard, {
    accent: "violet",
    style: {
      borderLeft: "3px solid var(--brand-violet)"
    }
  }, /*#__PURE__*/React.createElement("div", {
    className: "tp-ctitle",
    style: {
      marginBottom: ".6rem"
    }
  }, "\uD83D\uDCCA Semana en curso"), /*#__PURE__*/React.createElement("div", {
    style: {
      display: "grid",
      gridTemplateColumns: "repeat(2,1fr)",
      gap: 8
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      font: "13px var(--font-sans)"
    }
  }, /*#__PURE__*/React.createElement("span", {
    style: {
      fontWeight: 700,
      color: "var(--brand-violet)"
    }
  }, db.clases.length), /*#__PURE__*/React.createElement("span", {
    style: {
      color: "var(--fg-muted)"
    }
  }, " clase planificada")), /*#__PURE__*/React.createElement("div", {
    style: {
      font: "13px var(--font-sans)"
    }
  }, /*#__PURE__*/React.createElement("span", {
    style: {
      fontWeight: 700,
      color: "var(--mod-funcional)"
    }
  }, db.horarios.length - db.clases.length), /*#__PURE__*/React.createElement("span", {
    style: {
      color: "var(--fg-muted)"
    }
  }, " pendientes de planificar")), /*#__PURE__*/React.createElement("div", {
    style: {
      font: "13px var(--font-sans)"
    }
  }, /*#__PURE__*/React.createElement("span", {
    style: {
      fontWeight: 700,
      color: "var(--status-success)"
    }
  }, window.TP_money(recaudado)), /*#__PURE__*/React.createElement("span", {
    style: {
      color: "var(--fg-muted)"
    }
  }, " cobrado este mes")), /*#__PURE__*/React.createElement("div", {
    style: {
      font: "13px var(--font-sans)"
    }
  }, /*#__PURE__*/React.createElement("span", {
    style: {
      fontWeight: 700,
      color: "var(--brand-violet)"
    }
  }, pagaron), /*#__PURE__*/React.createElement("span", {
    style: {
      color: "var(--fg-muted)"
    }
  }, " alumnas pagaron este mes")))));
};

// ── Alumnas ─────────────────────────────────────────────────
const TPAlumnas = ({
  db,
  onEdit,
  onOpenFicha,
  onNueva
}) => {
  const activas = db.alumnas.filter(a => a.estado === "activa");
  const pausadas = db.alumnas.filter(a => a.estado === "pausada");
  const mes = db.mesActual;
  const diaHoy = new Date().getDate();
  const rowFor = a => {
    const inscs = window.TP_inscByAlumna(db, a.id);
    const pagoMes = db.pagos.filter(p => p.alumna_id === a.id && p.mes === mes);
    const todoPagado = inscs.length > 0 && pagoMes.some(p => p.pagado);
    const vencio = !a.dia_pago || a.dia_pago <= diaHoy;
    const pagoStatus = todoPagado ? {
      kind: "ok",
      label: "✓ Pagó"
    } : vencio ? {
      kind: "late",
      label: "Pendiente de pago"
    } : {
      kind: "upcoming",
      label: "Vence día " + a.dia_pago
    };
    return /*#__PURE__*/React.createElement(TPAlumnaRow, {
      key: a.id,
      alumna: a,
      inscs: inscs,
      pagoStatus: pagoStatus,
      onEdit: onEdit,
      onOpen: onOpenFicha
    });
  };
  return /*#__PURE__*/React.createElement(React.Fragment, null, /*#__PURE__*/React.createElement("div", {
    style: {
      display: "flex",
      alignItems: "center",
      justifyContent: "space-between",
      marginBottom: "1.25rem"
    }
  }, /*#__PURE__*/React.createElement("div", {
    className: "tp-ptitle",
    style: {
      margin: 0
    }
  }, "Alumnas (", activas.length, ")"), /*#__PURE__*/React.createElement("button", {
    className: "tp-btn tp-btn-primary",
    onClick: onNueva
  }, "+ Nueva alumna")), /*#__PURE__*/React.createElement(TPCard, {
    title: "Activas"
  }, activas.map(rowFor)), pausadas.length > 0 && /*#__PURE__*/React.createElement(TPCard, {
    title: "\u23F8 Pausadas"
  }, pausadas.map(rowFor)));
};

// ── Horarios ────────────────────────────────────────────────
const TPHorarios = ({
  db,
  onSlotClick
}) => {
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
    return n + "/" + cap + " · " + left + " libre" + (left !== 1 ? 's' : '');
  };
  return /*#__PURE__*/React.createElement(React.Fragment, null, /*#__PURE__*/React.createElement("div", {
    className: "tp-ptitle"
  }, "Horarios"), /*#__PURE__*/React.createElement(TPCard, null, /*#__PURE__*/React.createElement("div", {
    className: "tp-hgrid"
  }, dias.map(dia => {
    const slots = db.horarios.filter(h => h.dia === dia).sort((a, b) => a.hora_inicio.localeCompare(b.hora_inicio));
    return /*#__PURE__*/React.createElement("div", {
      className: "tp-hcol",
      key: dia
    }, /*#__PURE__*/React.createElement("div", {
      className: "tp-hday"
    }, window.TP_DIA_LABEL[dia]), slots.map(s => {
      const n = db.inscripciones.filter(i => i.horario_id === s.id).length;
      return /*#__PURE__*/React.createElement("div", {
        key: s.id,
        className: "tp-hslot " + s.modalidad,
        onClick: () => onSlotClick && onSlotClick(s)
      }, /*#__PURE__*/React.createElement("div", {
        className: "tp-hslot-time"
      }, s.hora_inicio, "\u2013", s.hora_fin), /*#__PURE__*/React.createElement("div", {
        className: "tp-hslot-mod " + s.modalidad
      }, window.TP_MOD_LABEL[s.modalidad]), /*#__PURE__*/React.createElement("div", {
        className: "tp-hslot-n",
        style: {
          color: capColor(n, s.capacidad)
        }
      }, capText(n, s.capacidad)));
    }));
  }))));
};

// ── Pagos ───────────────────────────────────────────────────
const TPPagos = ({
  db,
  onMarkPagado,
  onNuevoPago
}) => {
  const mes = db.mesActual;
  const activas = db.alumnas.filter(a => a.estado === "activa");
  return /*#__PURE__*/React.createElement(React.Fragment, null, /*#__PURE__*/React.createElement("div", {
    style: {
      display: "flex",
      alignItems: "center",
      justifyContent: "space-between",
      marginBottom: "1.25rem"
    }
  }, /*#__PURE__*/React.createElement("div", {
    className: "tp-ptitle",
    style: {
      margin: 0
    }
  }, "Pagos"), /*#__PURE__*/React.createElement("button", {
    className: "tp-btn tp-btn-primary",
    onClick: onNuevoPago
  }, "+ Registrar pago")), /*#__PURE__*/React.createElement(TPCard, {
    title: "Pagos · " + window.TP_mesLabel(mes)
  }, activas.map(a => {
    const inscs = window.TP_inscByAlumna(db, a.id);
    const monto = inscs.reduce((s, i) => s + (i.precio || 0), 0);
    const pagado = db.pagos.find(p => p.alumna_id === a.id && p.mes === mes && p.pagado);
    return /*#__PURE__*/React.createElement("div", {
      key: a.id,
      style: {
        display: "flex",
        alignItems: "center",
        gap: 10,
        padding: "8px 0",
        borderBottom: "1px solid var(--border)"
      }
    }, /*#__PURE__*/React.createElement("div", {
      className: "tp-avatar",
      style: {
        width: 30,
        height: 30,
        fontSize: 11
      }
    }, window.TP_alumnaInits(a.nombre, a.apellido)), /*#__PURE__*/React.createElement("div", {
      style: {
        flex: 1,
        font: "13px var(--font-sans)"
      }
    }, a.nombre, " ", a.apellido), /*#__PURE__*/React.createElement("div", {
      style: {
        font: "13px var(--font-sans)",
        color: "var(--fg-muted)",
        minWidth: 90,
        textAlign: "right"
      }
    }, window.TP_money(monto)), pagado ? /*#__PURE__*/React.createElement("span", {
      className: "tp-pago-pill ok"
    }, "\u2713 Pagado \xB7 ", pagado.fecha) : /*#__PURE__*/React.createElement("button", {
      className: "tp-btn tp-btn-small tp-btn-primary",
      onClick: () => onMarkPagado(a.id)
    }, "Marcar pagado"));
  })));
};

// ── Modal: Nueva alumna ─────────────────────────────────────
const TPModalAlumna = ({
  onCancel,
  onSave
}) => {
  const [form, setForm] = useState({
    nombre: "",
    apellido: "",
    tel: "",
    email: "",
    notas: "",
    contra: "",
    dia_pago: "",
    nacimiento: ""
  });
  const set = k => e => setForm({
    ...form,
    [k]: e.target.value
  });
  return /*#__PURE__*/React.createElement("div", {
    className: "tp-modal-bg",
    onClick: e => e.target === e.currentTarget && onCancel()
  }, /*#__PURE__*/React.createElement("div", {
    className: "tp-modal",
    onClick: e => e.stopPropagation()
  }, /*#__PURE__*/React.createElement("h3", null, "Nueva alumna"), /*#__PURE__*/React.createElement("div", {
    className: "tp-frow"
  }, /*#__PURE__*/React.createElement("div", null, /*#__PURE__*/React.createElement("label", null, "Nombre *"), /*#__PURE__*/React.createElement("input", {
    value: form.nombre,
    onChange: set("nombre"),
    placeholder: "Ej: Mar\xEDa"
  })), /*#__PURE__*/React.createElement("div", null, /*#__PURE__*/React.createElement("label", null, "Apellido"), /*#__PURE__*/React.createElement("input", {
    value: form.apellido,
    onChange: set("apellido"),
    placeholder: "Ej: Gonz\xE1lez"
  }))), /*#__PURE__*/React.createElement("div", {
    className: "tp-frow"
  }, /*#__PURE__*/React.createElement("div", null, /*#__PURE__*/React.createElement("label", null, "Tel\xE9fono (WhatsApp)"), /*#__PURE__*/React.createElement("input", {
    value: form.tel,
    onChange: set("tel"),
    placeholder: "5491112345678"
  })), /*#__PURE__*/React.createElement("div", null, /*#__PURE__*/React.createElement("label", null, "Email"), /*#__PURE__*/React.createElement("input", {
    value: form.email,
    onChange: set("email"),
    placeholder: "maria@gmail.com"
  }))), /*#__PURE__*/React.createElement("label", null, "Notas"), /*#__PURE__*/React.createElement("textarea", {
    value: form.notas,
    onChange: set("notas"),
    placeholder: "Preferencias, observaciones generales..."
  }), /*#__PURE__*/React.createElement("label", {
    style: {
      color: "var(--status-danger)",
      fontWeight: 600
    }
  }, "\uD83C\uDFE5 Contraindicaciones / Lesiones"), /*#__PURE__*/React.createElement("textarea", {
    value: form.contra,
    onChange: set("contra"),
    placeholder: "Ej: Rodilla derecha \u2014 sin flexi\xF3n profunda \xB7 Hernia lumbar L4-L5",
    style: {
      height: 52,
      borderColor: "var(--status-danger)"
    }
  }), /*#__PURE__*/React.createElement("div", {
    className: "tp-frow",
    style: {
      marginTop: 4
    }
  }, /*#__PURE__*/React.createElement("div", null, /*#__PURE__*/React.createElement("label", null, "D\xEDa de pago (1\u201331)"), /*#__PURE__*/React.createElement("input", {
    type: "number",
    min: "1",
    max: "31",
    value: form.dia_pago,
    onChange: set("dia_pago"),
    placeholder: "Ej: 10"
  })), /*#__PURE__*/React.createElement("div", null, /*#__PURE__*/React.createElement("label", null, "Fecha de nacimiento"), /*#__PURE__*/React.createElement("input", {
    type: "date",
    value: form.nacimiento,
    onChange: set("nacimiento")
  }))), /*#__PURE__*/React.createElement("div", {
    style: {
      display: "flex",
      gap: 8,
      justifyContent: "flex-end",
      marginTop: ".75rem"
    }
  }, /*#__PURE__*/React.createElement("button", {
    className: "tp-btn",
    onClick: onCancel
  }, "Cancelar"), /*#__PURE__*/React.createElement("button", {
    className: "tp-btn tp-btn-primary",
    onClick: () => onSave(form)
  }, "Guardar"))));
};
Object.assign(window, {
  TPLogin,
  TPInicio,
  TPAlumnas,
  TPHorarios,
  TPPagos,
  TPModalAlumna
});
})(); } catch (e) { __ds_ns.__errors.push({ path: "ui_kits/teacher-panel/TeacherScreens.jsx", error: String((e && e.message) || e) }); }

// ui_kits/teacher-panel/browser-window.jsx
try { (() => {
// Chrome.jsx — Simplified Chrome browser window (dark theme, macOS)
// No dependencies, no image assets. All inline styles + inline SVG.

const CHROME_C = {
  barBg: '#202124',
  tabBg: '#35363a',
  text: '#e8eaed',
  dim: '#9aa0a6',
  urlBg: '#282a2d'
};
function ChromeTrafficLights() {
  return /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      gap: 8,
      padding: '0 14px'
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      width: 12,
      height: 12,
      borderRadius: '50%',
      background: '#ff5f57'
    }
  }), /*#__PURE__*/React.createElement("div", {
    style: {
      width: 12,
      height: 12,
      borderRadius: '50%',
      background: '#febc2e'
    }
  }), /*#__PURE__*/React.createElement("div", {
    style: {
      width: 12,
      height: 12,
      borderRadius: '50%',
      background: '#28c840'
    }
  }));
}

// Single tab (active has curved scoops)
function ChromeTab({
  title = 'New Tab',
  active = false
}) {
  const curve = flip => /*#__PURE__*/React.createElement("svg", {
    width: "8",
    height: "10",
    viewBox: "0 0 8 10",
    style: {
      position: 'absolute',
      bottom: 0,
      [flip ? 'right' : 'left']: -8,
      transform: flip ? 'scaleX(-1)' : 'none'
    }
  }, /*#__PURE__*/React.createElement("path", {
    d: "M0 10C2 9 6 8 8 0V10H0Z",
    fill: CHROME_C.tabBg
  }));
  return /*#__PURE__*/React.createElement("div", {
    style: {
      position: 'relative',
      height: 34,
      alignSelf: 'flex-end',
      padding: '0 12px',
      display: 'flex',
      alignItems: 'center',
      gap: 8,
      background: active ? CHROME_C.tabBg : 'transparent',
      borderRadius: '8px 8px 0 0',
      minWidth: 120,
      maxWidth: 220,
      fontFamily: 'system-ui, sans-serif',
      fontSize: 12,
      color: active ? CHROME_C.text : CHROME_C.dim
    }
  }, active && curve(false), active && curve(true), /*#__PURE__*/React.createElement("div", {
    style: {
      width: 14,
      height: 14,
      borderRadius: '50%',
      background: '#5f6368',
      flexShrink: 0
    }
  }), /*#__PURE__*/React.createElement("span", {
    style: {
      flex: 1,
      whiteSpace: 'nowrap',
      overflow: 'hidden',
      textOverflow: 'ellipsis'
    }
  }, title));
}
function ChromeTabBar({
  tabs = [{
    title: 'New Tab'
  }],
  activeIndex = 0
}) {
  return /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      alignItems: 'center',
      height: 44,
      background: CHROME_C.barBg,
      paddingRight: 8
    }
  }, /*#__PURE__*/React.createElement(ChromeTrafficLights, null), /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      alignItems: 'flex-end',
      height: '100%',
      paddingLeft: 4,
      flex: 1
    }
  }, tabs.map((t, i) => /*#__PURE__*/React.createElement(ChromeTab, {
    key: i,
    title: t.title,
    active: i === activeIndex
  }))));
}
function ChromeToolbar({
  url = 'example.com'
}) {
  const iconDot = /*#__PURE__*/React.createElement("div", {
    style: {
      width: 28,
      height: 28,
      display: 'flex',
      alignItems: 'center',
      justifyContent: 'center'
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      width: 16,
      height: 16,
      borderRadius: '50%',
      background: CHROME_C.dim,
      opacity: 0.4
    }
  }));
  return /*#__PURE__*/React.createElement("div", {
    style: {
      height: 40,
      background: CHROME_C.tabBg,
      display: 'flex',
      alignItems: 'center',
      gap: 4,
      padding: '0 8px'
    }
  }, iconDot, /*#__PURE__*/React.createElement("div", {
    style: {
      flex: 1,
      height: 30,
      borderRadius: 15,
      background: CHROME_C.urlBg,
      display: 'flex',
      alignItems: 'center',
      gap: 8,
      padding: '0 14px',
      margin: '0 6px'
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      width: 12,
      height: 12,
      borderRadius: '50%',
      background: CHROME_C.dim,
      opacity: 0.4
    }
  }), /*#__PURE__*/React.createElement("span", {
    style: {
      flex: 1,
      color: CHROME_C.text,
      fontSize: 13,
      fontFamily: 'system-ui, sans-serif'
    }
  }, url)), iconDot);
}
function ChromeWindow({
  tabs = [{
    title: 'New Tab'
  }],
  activeIndex = 0,
  url = 'example.com',
  width = 900,
  height = 600,
  children
}) {
  return /*#__PURE__*/React.createElement("div", {
    style: {
      width,
      height,
      borderRadius: 10,
      overflow: 'hidden',
      boxShadow: '0 24px 80px rgba(0,0,0,0.35), 0 0 0 1px rgba(0,0,0,0.1)',
      display: 'flex',
      flexDirection: 'column',
      background: CHROME_C.tabBg
    }
  }, /*#__PURE__*/React.createElement(ChromeTabBar, {
    tabs: tabs,
    activeIndex: activeIndex
  }), /*#__PURE__*/React.createElement(ChromeToolbar, {
    url: url
  }), /*#__PURE__*/React.createElement("div", {
    style: {
      flex: 1,
      background: '#fff',
      overflow: 'auto'
    }
  }, children));
}
Object.assign(window, {
  ChromeWindow,
  ChromeTabBar,
  ChromeToolbar,
  ChromeTab,
  ChromeTrafficLights
});
})(); } catch (e) { __ds_ns.__errors.push({ path: "ui_kits/teacher-panel/browser-window.jsx", error: String((e && e.message) || e) }); }

// ui_kits/teacher-panel/data.js
try { (() => {
// data.js — fixture data for the teacher panel kit
// Shape mirrors the DB.* structures used by panel/index.html.

window.TP_DIA_LABEL = {
  lun: "Lunes",
  mar: "Martes",
  mie: "Miércoles",
  jue: "Jueves",
  vie: "Viernes"
};
window.TP_MOD_LABEL = {
  mat: "Mat",
  reformer: "Reformer",
  funcional: "Funcional"
};
const today = new Date();
const mesActual = today.toISOString().slice(0, 7);
window.TP_FIXTURE = {
  mesActual,
  alumnas: [{
    id: 1,
    nombre: "María",
    apellido: "González",
    tel: "5491140012345",
    estado: "activa",
    dia_pago: 10,
    nacimiento: "1988-03-21"
  }, {
    id: 2,
    nombre: "Sofía",
    apellido: "Pérez",
    tel: "5491140012346",
    estado: "activa",
    dia_pago: 5,
    nacimiento: "1991-09-14"
  }, {
    id: 3,
    nombre: "Lucía",
    apellido: "Ramírez",
    tel: "5491140012347",
    estado: "activa",
    dia_pago: 15,
    nacimiento: "1985-06-30"
  }, {
    id: 4,
    nombre: "Valentina",
    apellido: "Acosta",
    tel: "5491140012348",
    estado: "activa",
    dia_pago: 20,
    nacimiento: "1994-11-02"
  }, {
    id: 5,
    nombre: "Camila",
    apellido: "Soto",
    tel: "5491140012349",
    estado: "activa",
    dia_pago: 1,
    nacimiento: "1990-04-18"
  }, {
    id: 6,
    nombre: "Florencia",
    apellido: "Méndez",
    tel: "5491140012350",
    estado: "activa",
    dia_pago: 8,
    nacimiento: "1987-12-09"
  }, {
    id: 7,
    nombre: "Renata",
    apellido: "Bianchi",
    tel: "5491140012351",
    estado: "pausada",
    dia_pago: 12
  }, {
    id: 8,
    nombre: "Antonella",
    apellido: "Ferreyra",
    tel: "5491140012352",
    estado: "activa",
    dia_pago: 25,
    nacimiento: "1992-07-22"
  }],
  horarios: [{
    id: 1,
    dia: "lun",
    hora_inicio: "08:00",
    hora_fin: "09:00",
    modalidad: "reformer",
    capacidad: 4
  }, {
    id: 2,
    dia: "lun",
    hora_inicio: "09:30",
    hora_fin: "10:30",
    modalidad: "reformer",
    capacidad: 4
  }, {
    id: 3,
    dia: "lun",
    hora_inicio: "18:00",
    hora_fin: "19:00",
    modalidad: "mat",
    capacidad: 6
  }, {
    id: 4,
    dia: "mar",
    hora_inicio: "08:00",
    hora_fin: "09:00",
    modalidad: "funcional",
    capacidad: 8
  }, {
    id: 5,
    dia: "mar",
    hora_inicio: "18:00",
    hora_fin: "19:00",
    modalidad: "reformer",
    capacidad: 4
  }, {
    id: 6,
    dia: "mie",
    hora_inicio: "09:30",
    hora_fin: "10:30",
    modalidad: "reformer",
    capacidad: 4
  }, {
    id: 7,
    dia: "mie",
    hora_inicio: "18:00",
    hora_fin: "19:00",
    modalidad: "mat",
    capacidad: 6
  }, {
    id: 8,
    dia: "jue",
    hora_inicio: "08:00",
    hora_fin: "09:00",
    modalidad: "funcional",
    capacidad: 8
  }, {
    id: 9,
    dia: "jue",
    hora_inicio: "19:00",
    hora_fin: "20:00",
    modalidad: "reformer",
    capacidad: 4
  }, {
    id: 10,
    dia: "vie",
    hora_inicio: "09:30",
    hora_fin: "10:30",
    modalidad: "mat",
    capacidad: 6
  }, {
    id: 11,
    dia: "vie",
    hora_inicio: "18:00",
    hora_fin: "19:00",
    modalidad: "reformer",
    capacidad: 4
  }],
  inscripciones: [{
    id: 1,
    alumna_id: 1,
    horario_id: 2,
    precio: 12500
  }, {
    id: 2,
    alumna_id: 1,
    horario_id: 6,
    precio: 12500
  }, {
    id: 3,
    alumna_id: 2,
    horario_id: 3,
    precio: 15000
  }, {
    id: 4,
    alumna_id: 2,
    horario_id: 7,
    precio: 15000
  }, {
    id: 5,
    alumna_id: 3,
    horario_id: 5,
    precio: 25000
  }, {
    id: 6,
    alumna_id: 4,
    horario_id: 1,
    precio: 25000
  }, {
    id: 7,
    alumna_id: 4,
    horario_id: 9,
    precio: 25000
  }, {
    id: 8,
    alumna_id: 5,
    horario_id: 4,
    precio: 18000
  }, {
    id: 9,
    alumna_id: 5,
    horario_id: 8,
    precio: 18000
  }, {
    id: 10,
    alumna_id: 6,
    horario_id: 10,
    precio: 15000
  }, {
    id: 11,
    alumna_id: 8,
    horario_id: 11,
    precio: 25000
  }, {
    id: 12,
    alumna_id: 8,
    horario_id: 9,
    precio: 25000
  }],
  pagos: [{
    id: 1,
    alumna_id: 1,
    mes: mesActual,
    monto: 25000,
    pagado: true,
    fecha: today.toISOString().slice(0, 10)
  }, {
    id: 2,
    alumna_id: 3,
    mes: mesActual,
    monto: 25000,
    pagado: true,
    fecha: today.toISOString().slice(0, 10)
  }, {
    id: 3,
    alumna_id: 4,
    mes: mesActual,
    monto: 50000,
    pagado: true,
    fecha: today.toISOString().slice(0, 10)
  }, {
    id: 4,
    alumna_id: 6,
    mes: mesActual,
    monto: 15000,
    pagado: true,
    fecha: today.toISOString().slice(0, 10)
  }],
  clases: [{
    id: 1,
    horario_id: 2,
    fecha: today.toISOString().slice(0, 10),
    ejercicios: [{
      nombre: "Hundred",
      variante: "intermedio"
    }, {
      nombre: "Roll up",
      variante: "asistido"
    }, {
      nombre: "Single leg stretch",
      variante: null
    }, {
      nombre: "Footwork series",
      variante: "spring 2 rojos"
    }, {
      nombre: "Short box · round back",
      variante: null
    }, {
      nombre: "Stretches finales",
      variante: null
    }]
  }]
};
window.TP_money = n => "$" + Number(n || 0).toLocaleString("es-AR");
window.TP_mesLabel = m => {
  if (!m) return "";
  const [y, mo] = m.split("-");
  const meses = ["", "Ene", "Feb", "Mar", "Abr", "May", "Jun", "Jul", "Ago", "Sep", "Oct", "Nov", "Dic"];
  return `${meses[parseInt(mo)]} ${y}`;
};
window.TP_alumnaInits = (n, a) => ((n || "?")[0] + ((a || "")[0] || "")).toUpperCase();
window.TP_inscByAlumna = (db, alumnaId) => db.inscripciones.filter(i => i.alumna_id === alumnaId).map(i => ({
  ...i,
  horario: db.horarios.find(h => h.id === i.horario_id)
}));
})(); } catch (e) { __ds_ns.__errors.push({ path: "ui_kits/teacher-panel/data.js", error: String((e && e.message) || e) }); }

// ui_kits/teacher-panel/design-canvas.jsx
try { (() => {
// @ds-adherence-ignore -- omelette starter scaffold (raw elements/hex/px by design)

/* BEGIN USAGE */
// DesignCanvas.jsx — Figma-ish design canvas wrapper
// Warm gray grid bg + Sections + Artboards + PostIt notes.
// Exports (to window): DesignCanvas, DCSection, DCArtboard, DCPostIt.
// Artboards are reorderable (grip-drag), deletable, labels/titles are
// inline-editable, and any artboard can be opened in a fullscreen focus
// overlay (←/→/Esc). State persists to a .design-canvas.state.json sidecar
// via the host bridge. No assets, no deps.
//
// Usage:
//   <DesignCanvas>
//     <DCSection id="onboarding" title="Onboarding" subtitle="First-run variants">
//       <DCArtboard id="a" label="A · Dusk" width={260} height={480}>…</DCArtboard>
//       <DCArtboard id="b" label="B · Minimal" width={260} height={480}>…</DCArtboard>
//     </DCSection>
//   </DesignCanvas>
//
// Artboards are static design frames, not scroll regions — never use
// height: 100% + overflow: auto/scroll on inner elements; size each artboard
// to fit its content (explicit pixel height, or let it grow).
/* END USAGE */

const DC = {
  bg: '#f0eee9',
  grid: 'rgba(0,0,0,0.06)',
  label: 'rgba(60,50,40,0.7)',
  title: 'rgba(40,30,20,0.85)',
  subtitle: 'rgba(60,50,40,0.6)',
  postitBg: '#fef4a8',
  postitText: '#5a4a2a',
  font: '-apple-system, BlinkMacSystemFont, "Segoe UI", system-ui, sans-serif'
};

// One-time CSS injection (classes are dc-prefixed so they don't collide with
// the hosted design's own styles).
if (typeof document !== 'undefined' && !document.getElementById('dc-styles')) {
  const s = document.createElement('style');
  s.id = 'dc-styles';
  s.textContent = ['.dc-editable{cursor:text;outline:none;white-space:nowrap;border-radius:3px;padding:0 2px;margin:0 -2px}', '.dc-editable:focus{background:#fff;box-shadow:0 0 0 1.5px #c96442}', '[data-dc-slot]{transition:transform .18s cubic-bezier(.2,.7,.3,1)}', '[data-dc-slot].dc-dragging{transition:none;z-index:10;pointer-events:none}', '[data-dc-slot].dc-dragging .dc-card{box-shadow:0 12px 40px rgba(0,0,0,.25),0 0 0 2px #c96442;transform:scale(1.02)}',
  // isolation:isolate contains artboard content's z-indexes so a
  // z-indexed child (sticky navbar etc.) can't paint over .dc-header or
  // the .dc-menu popover that drops into the top of the card.
  '.dc-card{isolation:isolate;transition:box-shadow .15s,transform .15s}', '.dc-card *{scrollbar-width:none}', '.dc-card *::-webkit-scrollbar{display:none}',
  // Per-artboard header: grip + label on the left, delete/expand on the
  // right. Single flex row; when the artboard's on-screen width is too
  // narrow for both the label yields (ellipsis, then hidden entirely below
  // ~4ch via the container query) and the buttons stay on the row.
  '.dc-header{position:absolute;bottom:100%;left:-4px;margin-bottom:calc(4px * var(--dc-inv-zoom,1));z-index:2;', '  display:flex;align-items:center;container-type:inline-size}', '.dc-labelrow{display:flex;align-items:center;gap:4px;height:24px;flex:1 1 auto;min-width:0}', '.dc-grip{flex:0 0 auto;cursor:grab;display:flex;align-items:center;padding:5px 4px;border-radius:4px;transition:background .12s,opacity .12s}', '.dc-grip:hover{background:rgba(0,0,0,.08)}', '.dc-grip:active{cursor:grabbing}', '.dc-labeltext{flex:1 1 auto;min-width:0;cursor:pointer;border-radius:4px;padding:3px 6px;', '  display:flex;align-items:center;transition:background .12s;overflow:hidden}',
  // Below ~4ch of label room: hide the label entirely, and drop the grip to
  // hover-only (same reveal rule as .dc-btns) so a narrow header is clean
  // until the card is moused.
  '@container (max-width: 110px){', '  .dc-labeltext{display:none}', '  .dc-grip{opacity:0}', '  [data-dc-slot]:hover .dc-grip{opacity:1}', '}', '.dc-labeltext:hover{background:rgba(0,0,0,.05)}', '.dc-labeltext .dc-editable{overflow:hidden;text-overflow:ellipsis;max-width:100%}', '.dc-labeltext .dc-editable:focus{overflow:visible;text-overflow:clip}', '.dc-btns{flex:0 0 auto;margin-left:auto;display:flex;gap:2px;opacity:0;transition:opacity .12s}', '[data-dc-slot]:hover .dc-btns,.dc-btns:has(.dc-menu){opacity:1}', '.dc-expand,.dc-kebab{width:22px;height:22px;border-radius:5px;border:none;cursor:pointer;padding:0;', '  background:transparent;color:rgba(60,50,40,.7);display:flex;align-items:center;justify-content:center;', '  font:inherit;transition:background .12s,color .12s}', '.dc-expand:hover,.dc-kebab:hover{background:rgba(0,0,0,.06);color:#2a251f}',
  // Slot hosting an open menu floats above later siblings (which otherwise
  // paint on top — same z-index:auto, later DOM order) so the popup isn't
  // clipped by the next card.
  '[data-dc-slot]:has(.dc-menu){z-index:10}', '.dc-menu{position:absolute;top:100%;right:0;margin-top:4px;background:#fff;border-radius:8px;', '  box-shadow:0 8px 28px rgba(0,0,0,.18),0 0 0 1px rgba(0,0,0,.05);padding:4px;min-width:160px;z-index:10}', '.dc-menu button{display:block;width:100%;padding:7px 10px;border:0;background:transparent;', '  border-radius:5px;font-family:inherit;font-size:13px;font-weight:500;line-height:1.2;', '  color:#29261b;cursor:pointer;text-align:left;transition:background .12s;white-space:nowrap}', '.dc-menu button:hover{background:rgba(0,0,0,.05)}', '.dc-menu hr{border:0;border-top:1px solid rgba(0,0,0,.08);margin:4px 2px}', '.dc-menu .dc-danger{color:#c96442}', '.dc-menu .dc-danger:hover{background:rgba(201,100,66,.1)}',
  // Chrome (titles / labels / buttons) counter-scales against the viewport
  // zoom so it stays a constant on-screen size. --dc-inv-zoom is set by
  // DCViewport on every transform update and inherits to all descendants —
  // any overlay inside the world (e.g. a TweaksPanel on an artboard) can use
  // it the same way.
  //
  // The header uses transform:scale (out-of-flow, so layout impact doesn't
  // matter) with its world-space width set to card-width / inv-zoom so that
  // after counter-scaling its on-screen width exactly matches the card's —
  // that's what lets the container query + text-overflow behave against the
  // card's visible edge at every zoom level.
  //
  // The section head uses CSS zoom instead of transform so its layout box
  // grows with the counter-scale, pushing the card row down — otherwise the
  // constant-screen-size title would overflow into the (shrinking) world-
  // space gap and overlap the artboard headers at low zoom.
  '.dc-header{width:calc((100% + 4px) / var(--dc-inv-zoom,1));', '  transform:scale(var(--dc-inv-zoom,1));transform-origin:bottom left}', '.dc-sectionhead{zoom:var(--dc-inv-zoom,1)}'].join('\n');
  document.head.appendChild(s);
}
const DCCtx = React.createContext(null);

// Recursively unwrap React.Fragment so <>…</> grouping doesn't hide
// DCSection/DCArtboard children from the type-based walks below.
function dcFlatten(children) {
  const out = [];
  React.Children.forEach(children, c => {
    if (c && c.type === React.Fragment) out.push(...dcFlatten(c.props.children));else out.push(c);
  });
  return out;
}

// ─────────────────────────────────────────────────────────────
// DesignCanvas — stateful wrapper around the pan/zoom viewport.
// Owns runtime state (per-section order, renamed titles/labels, hidden
// artboards, focused artboard). Order/titles/labels/hidden persist to a
// .design-canvas.state.json
// sidecar next to the HTML. Reads go via plain fetch() so the saved
// arrangement is visible anywhere the HTML + sidecar are served together
// (omelette preview, direct link, downloaded zip). Writes go through the
// host's window.omelette bridge — editing requires the omelette runtime.
// Focus is ephemeral.
// ─────────────────────────────────────────────────────────────
const DC_STATE_FILE = '.design-canvas.state.json';
function DesignCanvas({
  children,
  minScale,
  maxScale,
  style
}) {
  const [state, setState] = React.useState({
    sections: {},
    focus: null
  });
  // Hold rendering until the sidecar read settles so the saved order/titles
  // appear on first paint (no source-order flash). didRead gates writes until
  // the read settles so the empty initial state can't clobber a slow read;
  // skipNextWrite suppresses the one echo-write that would otherwise follow
  // hydration.
  const [ready, setReady] = React.useState(false);
  const didRead = React.useRef(false);
  const skipNextWrite = React.useRef(false);
  React.useEffect(() => {
    let off = false;
    fetch('./' + DC_STATE_FILE).then(r => r.ok ? r.json() : null).then(saved => {
      if (off || !saved || !saved.sections) return;
      skipNextWrite.current = true;
      setState(s => ({
        ...s,
        sections: saved.sections
      }));
    }).catch(() => {}).finally(() => {
      didRead.current = true;
      if (!off) setReady(true);
    });
    const t = setTimeout(() => {
      if (!off) setReady(true);
    }, 150);
    return () => {
      off = true;
      clearTimeout(t);
    };
  }, []);
  React.useEffect(() => {
    if (!didRead.current) return;
    if (skipNextWrite.current) {
      skipNextWrite.current = false;
      return;
    }
    const t = setTimeout(() => {
      window.omelette?.writeFile(DC_STATE_FILE, JSON.stringify({
        sections: state.sections
      })).catch(() => {});
    }, 250);
    return () => clearTimeout(t);
  }, [state.sections]);

  // Build registries synchronously from children so FocusOverlay can read
  // them in the same render. Fragments are flattened; wrapping in other
  // elements still opts out of focus/reorder.
  const registry = {}; // slotId -> { sectionId, artboard }
  const sectionMeta = {}; // sectionId -> { title, subtitle, slotIds[] }
  const sectionOrder = [];
  dcFlatten(children).forEach(sec => {
    if (!sec || sec.type !== DCSection) return;
    const sid = sec.props.id ?? sec.props.title;
    if (!sid) return;
    sectionOrder.push(sid);
    const persisted = state.sections[sid] || {};
    const abs = [];
    dcFlatten(sec.props.children).forEach(ab => {
      if (!ab || ab.type !== DCArtboard) return;
      const aid = ab.props.id ?? ab.props.label;
      if (aid) abs.push([aid, ab]);
    });
    // hidden is scoped to one source revision — when the agent regenerates
    // (artboard-ID set changes), prior deletes don't apply to new content.
    const srcKey = abs.map(([k]) => k).join('\x1f');
    const hidden = persisted.srcKey === srcKey ? persisted.hidden || [] : [];
    const srcIds = [];
    abs.forEach(([aid, ab]) => {
      if (hidden.includes(aid)) return;
      registry[`${sid}/${aid}`] = {
        sectionId: sid,
        artboard: ab
      };
      srcIds.push(aid);
    });
    const kept = (persisted.order || []).filter(k => srcIds.includes(k));
    sectionMeta[sid] = {
      title: persisted.title ?? sec.props.title,
      subtitle: sec.props.subtitle,
      slotIds: [...kept, ...srcIds.filter(k => !kept.includes(k))]
    };
  });
  const api = React.useMemo(() => ({
    state,
    section: id => state.sections[id] || {},
    patchSection: (id, p) => setState(s => ({
      ...s,
      sections: {
        ...s.sections,
        [id]: {
          ...s.sections[id],
          ...(typeof p === 'function' ? p(s.sections[id] || {}) : p)
        }
      }
    })),
    setFocus: slotId => setState(s => ({
      ...s,
      focus: slotId
    }))
  }), [state]);

  // Esc exits focus; any outside pointerdown commits an in-progress rename.
  React.useEffect(() => {
    const onKey = e => {
      if (e.key === 'Escape') api.setFocus(null);
    };
    const onPd = e => {
      const ae = document.activeElement;
      if (ae && ae.isContentEditable && !ae.contains(e.target)) ae.blur();
    };
    document.addEventListener('keydown', onKey);
    document.addEventListener('pointerdown', onPd, true);
    return () => {
      document.removeEventListener('keydown', onKey);
      document.removeEventListener('pointerdown', onPd, true);
    };
  }, [api]);
  return /*#__PURE__*/React.createElement(DCCtx.Provider, {
    value: api
  }, /*#__PURE__*/React.createElement(DCViewport, {
    minScale: minScale,
    maxScale: maxScale,
    style: style
  }, ready && children), state.focus && registry[state.focus] && /*#__PURE__*/React.createElement(DCFocusOverlay, {
    entry: registry[state.focus],
    sectionMeta: sectionMeta,
    sectionOrder: sectionOrder
  }));
}

// ─────────────────────────────────────────────────────────────
// DCViewport — transform-based pan/zoom (internal)
//
// Input mapping (Figma-style):
//   • trackpad pinch  → zoom   (ctrlKey wheel; Safari gesture* events)
//   • trackpad scroll → pan    (two-finger)
//   • mouse wheel     → zoom   (notched; distinguished from trackpad scroll)
//   • middle-drag / primary-drag-on-bg → pan
//
// Transform state lives in a ref and is written straight to the DOM
// (translate3d + will-change) so wheel ticks don't go through React —
// keeps pans at 60fps on dense canvases.
// ─────────────────────────────────────────────────────────────
function DCViewport({
  children,
  minScale = 0.1,
  maxScale = 8,
  style = {}
}) {
  const vpRef = React.useRef(null);
  const worldRef = React.useRef(null);
  const tf = React.useRef({
    x: 0,
    y: 0,
    scale: 1
  });
  // Persist viewport across reloads so the user lands back where they were
  // after an agent edit or browser refresh. The sandbox origin is already
  // per-project; pathname keeps multiple canvas files in one project apart.
  const tfKey = 'dc-viewport:' + location.pathname;
  const saveT = React.useRef(0);
  const lastPostedScale = React.useRef();
  const apply = React.useCallback(() => {
    const {
      x,
      y,
      scale
    } = tf.current;
    const el = worldRef.current;
    if (!el) return;
    el.style.transform = `translate3d(${x}px, ${y}px, 0) scale(${scale})`;
    // Exposed for zoom-invariant chrome (labels, buttons, TweaksPanel).
    el.style.setProperty('--dc-inv-zoom', String(1 / scale));
    // Keep the host toolbar's % readout in sync with the canvas scale. Pan
    // ticks leave scale unchanged — skip the cross-frame post for those.
    if (lastPostedScale.current !== scale) {
      lastPostedScale.current = scale;
      window.parent.postMessage({
        type: '__dc_zoom',
        scale
      }, '*');
    }
    clearTimeout(saveT.current);
    saveT.current = setTimeout(() => {
      try {
        localStorage.setItem(tfKey, JSON.stringify(tf.current));
      } catch {}
    }, 200);
  }, [tfKey]);
  React.useLayoutEffect(() => {
    const flush = () => {
      clearTimeout(saveT.current);
      try {
        localStorage.setItem(tfKey, JSON.stringify(tf.current));
      } catch {}
    };
    try {
      const s = JSON.parse(localStorage.getItem(tfKey) || 'null');
      if (s && Number.isFinite(s.x) && Number.isFinite(s.y) && Number.isFinite(s.scale)) {
        tf.current = {
          x: s.x,
          y: s.y,
          scale: Math.min(maxScale, Math.max(minScale, s.scale))
        };
        apply();
      }
    } catch {}
    // Flush on pagehide and unmount so a reload within the 200ms debounce
    // window doesn't drop the last pan/zoom.
    window.addEventListener('pagehide', flush);
    return () => {
      window.removeEventListener('pagehide', flush);
      flush();
    };
  }, []);
  React.useEffect(() => {
    const vp = vpRef.current;
    if (!vp) return;
    const zoomAt = (cx, cy, factor) => {
      const r = vp.getBoundingClientRect();
      const px = cx - r.left,
        py = cy - r.top;
      const t = tf.current;
      const next = Math.min(maxScale, Math.max(minScale, t.scale * factor));
      const k = next / t.scale;
      // --dc-inv-zoom consumers (.dc-sectionhead's CSS zoom, each section's
      // marginBottom) reflow on every scale change, vertically shifting the
      // world layout — so a world point mathematically pinned under the cursor
      // drifts as you zoom (content creeps up on zoom-in, down on zoom-out).
      // Anchor the DOM element under the cursor instead: record its screen Y,
      // apply the transform + --dc-inv-zoom, then cancel whatever vertical
      // drift the reflow introduced so it stays put on screen.
      let marker = null,
        markerY0 = 0;
      if (k !== 1) {
        const hit = document.elementFromPoint(cx, cy);
        marker = hit && hit.closest ? hit.closest('[data-dc-slot],[data-dc-section]') : null;
        if (marker) markerY0 = marker.getBoundingClientRect().top;
      }
      // keep the world point under the cursor fixed
      t.x = px - (px - t.x) * k;
      t.y = py - (py - t.y) * k;
      t.scale = next;
      apply();
      if (marker) {
        // A pure zoom around (cx, cy) maps screen Y → cy + (Y - cy) * k. Any
        // departure after the --dc-inv-zoom reflow is the layout drift.
        const drift = marker.getBoundingClientRect().top - (cy + (markerY0 - cy) * k);
        if (Math.abs(drift) > 0.1) {
          t.y -= drift;
          apply();
        }
      }
    };

    // Mouse-wheel vs trackpad-scroll heuristic. A physical wheel sends
    // line-mode deltas (Firefox) or large integer pixel deltas with no X
    // component (Chrome/Safari, typically multiples of 100/120). Trackpad
    // two-finger scroll sends small/fractional pixel deltas, often with
    // non-zero deltaX. ctrlKey is set by the browser for trackpad pinch.
    const isMouseWheel = e => e.deltaMode !== 0 || e.deltaX === 0 && Number.isInteger(e.deltaY) && Math.abs(e.deltaY) >= 40;
    const onWheel = e => {
      e.preventDefault();
      if (isGesturing) return; // Safari: gesture* owns the pinch — discard concurrent wheels
      if ((e.ctrlKey || e.metaKey) && !isMouseWheel(e)) {
        // trackpad pinch, or ctrl/cmd + smooth-scroll mouse. Notched
        // wheels fall through to the fixed-step branch below.
        zoomAt(e.clientX, e.clientY, Math.exp(-e.deltaY * 0.01));
      } else if (isMouseWheel(e)) {
        // notched mouse wheel — fixed-ratio step per click
        zoomAt(e.clientX, e.clientY, Math.exp(-Math.sign(e.deltaY) * 0.18));
      } else {
        // trackpad two-finger scroll — pan
        tf.current.x -= e.deltaX;
        tf.current.y -= e.deltaY;
        apply();
      }
    };

    // Safari sends native gesture* events for trackpad pinch with a smooth
    // e.scale; preferring these over the ctrl+wheel fallback gives a much
    // better feel there. No-ops on other browsers. Safari also fires
    // ctrlKey wheel events during the same pinch — isGesturing makes
    // onWheel drop those entirely so they neither zoom nor pan.
    let gsBase = 1;
    let isGesturing = false;
    const onGestureStart = e => {
      e.preventDefault();
      isGesturing = true;
      gsBase = tf.current.scale;
    };
    const onGestureChange = e => {
      e.preventDefault();
      zoomAt(e.clientX, e.clientY, gsBase * e.scale / tf.current.scale);
    };
    const onGestureEnd = e => {
      e.preventDefault();
      isGesturing = false;
    };

    // Drag-pan: middle button anywhere, or primary button on canvas
    // background (anything that isn't an artboard or an inline editor).
    let drag = null;
    const onPointerDown = e => {
      const onBg = !e.target.closest('[data-dc-slot], .dc-editable');
      if (!(e.button === 1 || e.button === 0 && onBg)) return;
      e.preventDefault();
      vp.setPointerCapture(e.pointerId);
      drag = {
        id: e.pointerId,
        lx: e.clientX,
        ly: e.clientY
      };
      vp.style.cursor = 'grabbing';
    };
    const onPointerMove = e => {
      if (!drag || e.pointerId !== drag.id) return;
      tf.current.x += e.clientX - drag.lx;
      tf.current.y += e.clientY - drag.ly;
      drag.lx = e.clientX;
      drag.ly = e.clientY;
      apply();
    };
    const onPointerUp = e => {
      if (!drag || e.pointerId !== drag.id) return;
      vp.releasePointerCapture(e.pointerId);
      drag = null;
      vp.style.cursor = '';
    };

    // Host-driven zoom (toolbar % menu). Zooms around viewport centre so the
    // visible midpoint stays fixed — matching the host's iframe-zoom feel.
    const onHostMsg = e => {
      const d = e.data;
      if (d && d.type === '__dc_set_zoom' && typeof d.scale === 'number') {
        const r = vp.getBoundingClientRect();
        zoomAt(r.left + r.width / 2, r.top + r.height / 2, d.scale / tf.current.scale);
      } else if (d && d.type === '__dc_probe') {
        // Host's [readyGen] reset asks whether a canvas is present; it
        // fires on the iframe's native 'load', which for canvases with
        // images/fonts is after our mount-time announce, so re-announce.
        // Clear the pan-tick guard so apply() re-posts the current scale
        // even if it's unchanged — the host just reset dcScale to 1.
        window.parent.postMessage({
          type: '__dc_present'
        }, '*');
        lastPostedScale.current = undefined;
        apply();
      }
    };
    window.addEventListener('message', onHostMsg);
    // Announce canvas mode so the host toolbar proxies its % control here
    // instead of scaling the iframe element (which would just shrink the
    // viewport window of an infinite canvas). The apply() that follows emits
    // the initial __dc_zoom so the toolbar % is correct before first pinch.
    // lastPostedScale reset mirrors the __dc_probe handler: the layout
    // effect's restore-path apply() may already have posted the restored
    // scale (before __dc_present), so clear the guard to re-post it in order.
    window.parent.postMessage({
      type: '__dc_present'
    }, '*');
    lastPostedScale.current = undefined;
    apply();
    vp.addEventListener('wheel', onWheel, {
      passive: false
    });
    vp.addEventListener('gesturestart', onGestureStart, {
      passive: false
    });
    vp.addEventListener('gesturechange', onGestureChange, {
      passive: false
    });
    vp.addEventListener('gestureend', onGestureEnd, {
      passive: false
    });
    vp.addEventListener('pointerdown', onPointerDown);
    vp.addEventListener('pointermove', onPointerMove);
    vp.addEventListener('pointerup', onPointerUp);
    vp.addEventListener('pointercancel', onPointerUp);
    return () => {
      window.removeEventListener('message', onHostMsg);
      vp.removeEventListener('wheel', onWheel);
      vp.removeEventListener('gesturestart', onGestureStart);
      vp.removeEventListener('gesturechange', onGestureChange);
      vp.removeEventListener('gestureend', onGestureEnd);
      vp.removeEventListener('pointerdown', onPointerDown);
      vp.removeEventListener('pointermove', onPointerMove);
      vp.removeEventListener('pointerup', onPointerUp);
      vp.removeEventListener('pointercancel', onPointerUp);
    };
  }, [apply, minScale, maxScale]);
  const gridSvg = `url("data:image/svg+xml,%3Csvg width='120' height='120' xmlns='http://www.w3.org/2000/svg'%3E%3Cpath d='M120 0H0v120' fill='none' stroke='${encodeURIComponent(DC.grid)}' stroke-width='1'/%3E%3C/svg%3E")`;
  return /*#__PURE__*/React.createElement("div", {
    ref: vpRef,
    className: "design-canvas",
    style: {
      height: '100vh',
      width: '100vw',
      background: DC.bg,
      overflow: 'hidden',
      overscrollBehavior: 'none',
      touchAction: 'none',
      position: 'relative',
      fontFamily: DC.font,
      boxSizing: 'border-box',
      ...style
    }
  }, /*#__PURE__*/React.createElement("div", {
    ref: worldRef,
    style: {
      position: 'absolute',
      top: 0,
      left: 0,
      transformOrigin: '0 0',
      willChange: 'transform',
      width: 'max-content',
      minWidth: '100%',
      minHeight: '100%',
      padding: '60px 0 80px'
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      position: 'absolute',
      inset: -6000,
      backgroundImage: gridSvg,
      backgroundSize: '120px 120px',
      pointerEvents: 'none',
      zIndex: -1
    }
  }), children));
}

// ─────────────────────────────────────────────────────────────
// DCSection — editable title + h-row of artboards in persisted order
// ─────────────────────────────────────────────────────────────
function DCSection({
  id,
  title,
  subtitle,
  children,
  gap = 48
}) {
  const ctx = React.useContext(DCCtx);
  const sid = id ?? title;
  const all = React.Children.toArray(dcFlatten(children));
  const artboards = all.filter(c => c && c.type === DCArtboard);
  const rest = all.filter(c => !(c && c.type === DCArtboard));
  const sec = ctx && sid && ctx.section(sid) || {};
  // Must match DesignCanvas's srcKey computation exactly (it filters falsy
  // IDs), or onDelete persists a srcKey that DesignCanvas never recognizes.
  const allIds = artboards.map(a => a.props.id ?? a.props.label).filter(Boolean);
  const srcKey = allIds.join('\x1f');
  const hidden = sec.srcKey === srcKey ? sec.hidden || [] : [];
  const srcOrder = allIds.filter(k => !hidden.includes(k));
  const order = React.useMemo(() => {
    const kept = (sec.order || []).filter(k => srcOrder.includes(k));
    return [...kept, ...srcOrder.filter(k => !kept.includes(k))];
  }, [sec.order, srcOrder.join('|')]);
  const byId = Object.fromEntries(artboards.map(a => [a.props.id ?? a.props.label, a]));

  // marginBottom counter-scales so the on-screen gap between sections stays
  // constant — otherwise at low zoom the (world-space) gap collapses while
  // the screen-constant sectionhead below it doesn't, and the title reads as
  // belonging to the section above. paddingBottom below is just enough for
  // the 24px artboard-header (abs-positioned above each card) plus ~8px, so
  // the title sits tight against its own row at every zoom.
  return /*#__PURE__*/React.createElement("div", {
    "data-dc-section": sid,
    style: {
      marginBottom: 'calc(80px * var(--dc-inv-zoom, 1))',
      position: 'relative'
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      padding: '0 60px'
    }
  }, /*#__PURE__*/React.createElement("div", {
    className: "dc-sectionhead",
    style: {
      paddingBottom: 36
    }
  }, /*#__PURE__*/React.createElement(DCEditable, {
    tag: "div",
    value: sec.title ?? title,
    onChange: v => ctx && sid && ctx.patchSection(sid, {
      title: v
    }),
    style: {
      fontSize: 28,
      fontWeight: 600,
      color: DC.title,
      letterSpacing: -0.4,
      marginBottom: 6,
      display: 'inline-block'
    }
  }), subtitle && /*#__PURE__*/React.createElement("div", {
    style: {
      fontSize: 16,
      color: DC.subtitle
    }
  }, subtitle))), /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      gap,
      padding: '0 60px',
      alignItems: 'flex-start',
      width: 'max-content'
    }
  }, order.map(k => /*#__PURE__*/React.createElement(DCArtboardFrame, {
    key: k,
    sectionId: sid,
    artboard: byId[k],
    order: order,
    label: (sec.labels || {})[k] ?? byId[k].props.label,
    onRename: v => ctx && ctx.patchSection(sid, x => ({
      labels: {
        ...x.labels,
        [k]: v
      }
    })),
    onReorder: next => ctx && ctx.patchSection(sid, {
      order: next
    }),
    onDelete: () => ctx && ctx.patchSection(sid, x => ({
      hidden: [...(x.srcKey === srcKey ? x.hidden || [] : []), k],
      srcKey
    })),
    onFocus: () => ctx && ctx.setFocus(`${sid}/${k}`)
  }))), rest);
}

// DCArtboard — marker; rendered by DCArtboardFrame via DCSection.
function DCArtboard() {
  return null;
}

// Per-artboard export (kind: 'png' | 'html'). Both paths share the same
// self-contained clone: computed styles baked in, @font-face / <img> /
// inline-style background-image urls inlined as data URIs. PNG wraps the
// clone in foreignObject→canvas at 3× the artboard's natural width×height
// (same pipeline the host uses for page captures); HTML wraps it in a
// minimal standalone document. Both are independent of viewport zoom.
async function dcExport(node, w, h, name, kind) {
  try {
    await document.fonts.ready;
  } catch {}
  const toDataURL = url => fetch(url).then(r => r.blob()).then(b => new Promise(res => {
    const fr = new FileReader();
    fr.onload = () => res(fr.result);
    fr.onerror = () => res(url);
    fr.readAsDataURL(b);
  })).catch(() => url);

  // Collect @font-face rules. ss.cssRules throws SecurityError on
  // cross-origin sheets (e.g. fonts.googleapis.com) — in that case fetch
  // the CSS text directly (those endpoints send ACAO:*) and regex-extract
  // the blocks. @import and @media/@supports are walked so nested
  // @font-face rules aren't missed.
  const fontRules = [],
    pending = [],
    seen = new Set();
  const scrapeCss = href => {
    if (seen.has(href)) return;
    seen.add(href);
    pending.push(fetch(href).then(r => r.text()).then(css => {
      for (const m of css.match(/@font-face\s*{[^}]*}/g) || []) fontRules.push({
        css: m,
        base: href
      });
      for (const m of css.matchAll(/@import\s+(?:url\()?['"]?([^'")\s;]+)/g)) scrapeCss(new URL(m[1], href).href);
    }).catch(() => {}));
  };
  const walk = (rules, base) => {
    for (const r of rules) {
      if (r.type === CSSRule.FONT_FACE_RULE) fontRules.push({
        css: r.cssText,
        base
      });else if (r.type === CSSRule.IMPORT_RULE && r.styleSheet) {
        const ibase = r.styleSheet.href || base;
        try {
          walk(r.styleSheet.cssRules, ibase);
        } catch {
          scrapeCss(ibase);
        }
      } else if (r.cssRules) walk(r.cssRules, base);
    }
  };
  for (const ss of document.styleSheets) {
    const base = ss.href || location.href;
    try {
      walk(ss.cssRules, base);
    } catch {
      if (ss.href) scrapeCss(ss.href);
    }
  }
  while (pending.length) await pending.shift();
  const fontCss = (await Promise.all(fontRules.map(async rule => {
    let out = rule.css,
      m;
    const re = /url\((['"]?)([^'")]+)\1\)/g;
    while (m = re.exec(rule.css)) {
      if (m[2].indexOf('data:') === 0) continue;
      let abs;
      try {
        abs = new URL(m[2], rule.base).href;
      } catch {
        continue;
      }
      out = out.split(m[0]).join('url("' + (await toDataURL(abs)) + '")');
    }
    return out;
  }))).join('\n');
  const cloneStyled = src => {
    if (src.nodeType === 8 || src.nodeType === 1 && src.tagName === 'SCRIPT') return document.createTextNode('');
    const dst = src.cloneNode(false);
    if (src.nodeType === 1) {
      const cs = getComputedStyle(src);
      let txt = '';
      for (let i = 0; i < cs.length; i++) txt += cs[i] + ':' + cs.getPropertyValue(cs[i]) + ';';
      dst.setAttribute('style', txt + 'animation:none;transition:none;');
      if (src.tagName === 'CANVAS') try {
        const im = document.createElement('img');
        im.src = src.toDataURL();
        im.setAttribute('style', txt);
        return im;
      } catch {}
    }
    for (let c = src.firstChild; c; c = c.nextSibling) dst.appendChild(cloneStyled(c));
    return dst;
  };
  const clone = cloneStyled(node);
  clone.setAttribute('xmlns', 'http://www.w3.org/1999/xhtml');
  // Drop the card's own shadow/radius so the export is a flush w×h rect;
  // the artboard's own background (if any) is already in the computed style.
  clone.style.boxShadow = 'none';
  clone.style.borderRadius = '0';
  const jobs = [];
  clone.querySelectorAll('img').forEach(el => {
    const s = el.getAttribute('src');
    if (s && s.indexOf('data:') !== 0) jobs.push(toDataURL(el.src).then(d => el.setAttribute('src', d)));
  });
  [clone, ...clone.querySelectorAll('*')].forEach(el => {
    const bg = el.style.backgroundImage;
    if (!bg) return;
    let m;
    const re = /url\(["']?([^"')]+)["']?\)/g;
    while (m = re.exec(bg)) {
      const tok = m[0],
        url = m[1];
      if (url.indexOf('data:') === 0) continue;
      jobs.push(toDataURL(url).then(d => {
        el.style.backgroundImage = el.style.backgroundImage.split(tok).join('url("' + d + '")');
      }));
    }
  });
  await Promise.all(jobs);
  const xml = new XMLSerializer().serializeToString(clone);
  const save = (blob, ext) => {
    if (!blob) return;
    const a = document.createElement('a');
    a.href = URL.createObjectURL(blob);
    a.download = name + '.' + ext;
    a.click();
    setTimeout(() => URL.revokeObjectURL(a.href), 1000);
  };
  if (kind === 'html') {
    const html = '<!doctype html><html><head><meta charset="utf-8"><title>' + name + '</title>' + (fontCss ? '<style>' + fontCss + '</style>' : '') + '</head><body style="margin:0">' + xml + '</body></html>';
    return save(new Blob([html], {
      type: 'text/html'
    }), 'html');
  }

  // PNG: the SVG's own width/height must be the output resolution — an
  // <img>-loaded SVG rasterizes at its intrinsic size, so sizing it at 1×
  // and ctx.scale()-ing up would just upscale a 1× bitmap. viewBox maps the
  // w×h foreignObject onto the px·w × px·h SVG canvas so the browser renders
  // the HTML at full resolution.
  const px = 3;
  const svg = '<svg xmlns="http://www.w3.org/2000/svg" width="' + w * px + '" height="' + h * px + '" viewBox="0 0 ' + w + ' ' + h + '"><foreignObject width="' + w + '" height="' + h + '">' + (fontCss ? '<style><![CDATA[' + fontCss + ']]></style>' : '') + xml + '</foreignObject></svg>';
  const img = new Image();
  await new Promise((res, rej) => {
    img.onload = res;
    img.onerror = () => rej(new Error('svg load failed'));
    img.src = 'data:image/svg+xml;charset=utf-8,' + encodeURIComponent(svg);
  });
  const cv = document.createElement('canvas');
  cv.width = w * px;
  cv.height = h * px;
  cv.getContext('2d').drawImage(img, 0, 0);
  cv.toBlob(blob => save(blob, 'png'), 'image/png');
}
function DCArtboardFrame({
  sectionId,
  artboard,
  label,
  order,
  onRename,
  onReorder,
  onFocus,
  onDelete
}) {
  const {
    id: rawId,
    label: rawLabel,
    width = 260,
    height = 480,
    children,
    style = {}
  } = artboard.props;
  const id = rawId ?? rawLabel;
  const ref = React.useRef(null);
  const cardRef = React.useRef(null);
  const menuRef = React.useRef(null);
  const [menuOpen, setMenuOpen] = React.useState(false);
  const [confirming, setConfirming] = React.useState(false);

  // ⋯ menu: close on any outside pointerdown. Two-click delete lives inside
  // the menu — first click arms the row, second commits; closing disarms.
  React.useEffect(() => {
    if (!menuOpen) {
      setConfirming(false);
      return;
    }
    const off = e => {
      if (!menuRef.current || !menuRef.current.contains(e.target)) setMenuOpen(false);
    };
    document.addEventListener('pointerdown', off, true);
    return () => document.removeEventListener('pointerdown', off, true);
  }, [menuOpen]);
  const doExport = kind => {
    setMenuOpen(false);
    if (!cardRef.current) return;
    const name = String(label || id || 'artboard').replace(/[^\w\s.-]+/g, '_');
    dcExport(cardRef.current, width, height, name, kind).catch(e => console.error('[design-canvas] export failed:', e));
  };

  // Live drag-reorder: dragged card sticks to cursor; siblings slide into
  // their would-be slots in real time via transforms. DOM order only
  // changes on drop.
  const onGripDown = e => {
    e.preventDefault();
    e.stopPropagation();
    const me = ref.current;
    // translateX is applied in local (pre-scale) space but pointer deltas and
    // getBoundingClientRect().left are screen-space — divide by the viewport's
    // current scale so the dragged card tracks the cursor at any zoom level.
    const scale = me.getBoundingClientRect().width / me.offsetWidth || 1;
    const peers = Array.from(document.querySelectorAll(`[data-dc-section="${sectionId}"] [data-dc-slot]`));
    const homes = peers.map(el => ({
      el,
      id: el.dataset.dcSlot,
      x: el.getBoundingClientRect().left
    }));
    const slotXs = homes.map(h => h.x);
    const startIdx = order.indexOf(id);
    const startX = e.clientX;
    let liveOrder = order.slice();
    me.classList.add('dc-dragging');
    const layout = () => {
      for (const h of homes) {
        if (h.id === id) continue;
        const slot = liveOrder.indexOf(h.id);
        h.el.style.transform = `translateX(${(slotXs[slot] - h.x) / scale}px)`;
      }
    };
    const move = ev => {
      const dx = ev.clientX - startX;
      me.style.transform = `translateX(${dx / scale}px)`;
      const cur = homes[startIdx].x + dx;
      let nearest = 0,
        best = Infinity;
      for (let i = 0; i < slotXs.length; i++) {
        const d = Math.abs(slotXs[i] - cur);
        if (d < best) {
          best = d;
          nearest = i;
        }
      }
      if (liveOrder.indexOf(id) !== nearest) {
        liveOrder = order.filter(k => k !== id);
        liveOrder.splice(nearest, 0, id);
        layout();
      }
    };
    const up = () => {
      document.removeEventListener('pointermove', move);
      document.removeEventListener('pointerup', up);
      const finalSlot = liveOrder.indexOf(id);
      me.classList.remove('dc-dragging');
      me.style.transform = `translateX(${(slotXs[finalSlot] - homes[startIdx].x) / scale}px)`;
      // After the settle transition, kill transitions + clear transforms +
      // commit the reorder in the same frame so there's no visual snap-back.
      setTimeout(() => {
        for (const h of homes) {
          h.el.style.transition = 'none';
          h.el.style.transform = '';
        }
        if (liveOrder.join('|') !== order.join('|')) onReorder(liveOrder);
        requestAnimationFrame(() => requestAnimationFrame(() => {
          for (const h of homes) h.el.style.transition = '';
        }));
      }, 180);
    };
    document.addEventListener('pointermove', move);
    document.addEventListener('pointerup', up);
  };
  return /*#__PURE__*/React.createElement("div", {
    ref: ref,
    "data-dc-slot": id,
    style: {
      position: 'relative',
      flexShrink: 0
    }
  }, /*#__PURE__*/React.createElement("div", {
    className: "dc-header",
    "data-omelette-chrome": "",
    style: {
      color: DC.label
    },
    onPointerDown: e => e.stopPropagation()
  }, /*#__PURE__*/React.createElement("div", {
    className: "dc-labelrow"
  }, /*#__PURE__*/React.createElement("div", {
    className: "dc-grip",
    onPointerDown: onGripDown,
    title: "Drag to reorder"
  }, /*#__PURE__*/React.createElement("svg", {
    width: "9",
    height: "13",
    viewBox: "0 0 9 13",
    fill: "currentColor"
  }, /*#__PURE__*/React.createElement("circle", {
    cx: "2",
    cy: "2",
    r: "1.1"
  }), /*#__PURE__*/React.createElement("circle", {
    cx: "7",
    cy: "2",
    r: "1.1"
  }), /*#__PURE__*/React.createElement("circle", {
    cx: "2",
    cy: "6.5",
    r: "1.1"
  }), /*#__PURE__*/React.createElement("circle", {
    cx: "7",
    cy: "6.5",
    r: "1.1"
  }), /*#__PURE__*/React.createElement("circle", {
    cx: "2",
    cy: "11",
    r: "1.1"
  }), /*#__PURE__*/React.createElement("circle", {
    cx: "7",
    cy: "11",
    r: "1.1"
  }))), /*#__PURE__*/React.createElement("div", {
    className: "dc-labeltext",
    onClick: onFocus,
    title: "Click to focus"
  }, /*#__PURE__*/React.createElement(DCEditable, {
    value: label,
    onChange: onRename,
    onClick: e => e.stopPropagation(),
    style: {
      fontSize: 15,
      fontWeight: 500,
      color: DC.label,
      lineHeight: 1
    }
  }))), /*#__PURE__*/React.createElement("div", {
    className: "dc-btns"
  }, /*#__PURE__*/React.createElement("div", {
    ref: menuRef,
    style: {
      position: 'relative'
    }
  }, /*#__PURE__*/React.createElement("button", {
    className: "dc-kebab",
    title: "More",
    onClick: () => setMenuOpen(o => !o)
  }, /*#__PURE__*/React.createElement("svg", {
    width: "12",
    height: "12",
    viewBox: "0 0 12 12",
    fill: "currentColor"
  }, /*#__PURE__*/React.createElement("circle", {
    cx: "2.5",
    cy: "6",
    r: "1.1"
  }), /*#__PURE__*/React.createElement("circle", {
    cx: "6",
    cy: "6",
    r: "1.1"
  }), /*#__PURE__*/React.createElement("circle", {
    cx: "9.5",
    cy: "6",
    r: "1.1"
  }))), menuOpen && /*#__PURE__*/React.createElement("div", {
    className: "dc-menu",
    onPointerDown: e => e.stopPropagation()
  }, /*#__PURE__*/React.createElement("button", {
    onClick: () => doExport('png')
  }, "Download PNG"), /*#__PURE__*/React.createElement("button", {
    onClick: () => doExport('html')
  }, "Download HTML"), /*#__PURE__*/React.createElement("hr", null), /*#__PURE__*/React.createElement("button", {
    className: "dc-danger",
    onClick: () => {
      if (confirming) {
        setMenuOpen(false);
        onDelete();
      } else setConfirming(true);
    }
  }, confirming ? 'Click again to delete' : 'Delete'))), /*#__PURE__*/React.createElement("button", {
    className: "dc-expand",
    onClick: onFocus,
    title: "Focus"
  }, /*#__PURE__*/React.createElement("svg", {
    width: "12",
    height: "12",
    viewBox: "0 0 12 12",
    fill: "none",
    stroke: "currentColor",
    strokeWidth: "1.6",
    strokeLinecap: "round"
  }, /*#__PURE__*/React.createElement("path", {
    d: "M7 1h4v4M5 11H1V7M11 1L7.5 4.5M1 11l3.5-3.5"
  }))))), /*#__PURE__*/React.createElement("div", {
    ref: cardRef,
    className: "dc-card",
    style: {
      borderRadius: 2,
      boxShadow: '0 1px 3px rgba(0,0,0,.08),0 4px 16px rgba(0,0,0,.06)',
      overflow: 'hidden',
      width,
      height,
      background: '#fff',
      ...style
    }
  }, children || /*#__PURE__*/React.createElement("div", {
    style: {
      height: '100%',
      display: 'flex',
      alignItems: 'center',
      justifyContent: 'center',
      color: '#bbb',
      fontSize: 13,
      fontFamily: DC.font
    }
  }, id)));
}

// Inline rename — commits on blur or Enter.
function DCEditable({
  value,
  onChange,
  style,
  tag = 'span',
  onClick
}) {
  const T = tag;
  return /*#__PURE__*/React.createElement(T, {
    className: "dc-editable",
    contentEditable: true,
    suppressContentEditableWarning: true,
    onClick: onClick,
    onPointerDown: e => e.stopPropagation(),
    onBlur: e => onChange && onChange(e.currentTarget.textContent),
    onKeyDown: e => {
      if (e.key === 'Enter') {
        e.preventDefault();
        e.currentTarget.blur();
      }
    },
    style: style
  }, value);
}

// ─────────────────────────────────────────────────────────────
// Focus mode — overlay one artboard; ←/→ within section, ↑/↓ across
// sections, Esc or backdrop click to exit.
// ─────────────────────────────────────────────────────────────
function DCFocusOverlay({
  entry,
  sectionMeta,
  sectionOrder
}) {
  const ctx = React.useContext(DCCtx);
  const {
    sectionId,
    artboard
  } = entry;
  const sec = ctx.section(sectionId);
  const meta = sectionMeta[sectionId];
  const peers = meta.slotIds;
  const aid = artboard.props.id ?? artboard.props.label;
  const idx = peers.indexOf(aid);
  const secIdx = sectionOrder.indexOf(sectionId);
  const go = d => {
    const n = peers[(idx + d + peers.length) % peers.length];
    if (n) ctx.setFocus(`${sectionId}/${n}`);
  };
  const goSection = d => {
    // Sections whose artboards are all deleted have slotIds:[] — step past
    // them to the next non-empty section so ↑/↓ doesn't dead-end.
    const n = sectionOrder.length;
    for (let i = 1; i < n; i++) {
      const ns = sectionOrder[((secIdx + d * i) % n + n) % n];
      const first = sectionMeta[ns] && sectionMeta[ns].slotIds[0];
      if (first) {
        ctx.setFocus(`${ns}/${first}`);
        return;
      }
    }
  };
  React.useEffect(() => {
    const k = e => {
      if (e.key === 'ArrowLeft') {
        e.preventDefault();
        go(-1);
      }
      if (e.key === 'ArrowRight') {
        e.preventDefault();
        go(1);
      }
      if (e.key === 'ArrowUp') {
        e.preventDefault();
        goSection(-1);
      }
      if (e.key === 'ArrowDown') {
        e.preventDefault();
        goSection(1);
      }
    };
    document.addEventListener('keydown', k);
    return () => document.removeEventListener('keydown', k);
  });
  const {
    width = 260,
    height = 480,
    children
  } = artboard.props;
  const [vp, setVp] = React.useState({
    w: window.innerWidth,
    h: window.innerHeight
  });
  React.useEffect(() => {
    const r = () => setVp({
      w: window.innerWidth,
      h: window.innerHeight
    });
    window.addEventListener('resize', r);
    return () => window.removeEventListener('resize', r);
  }, []);
  const scale = Math.max(0.1, Math.min((vp.w - 200) / width, (vp.h - 260) / height, 2));
  const [ddOpen, setDd] = React.useState(false);
  const Arrow = ({
    dir,
    onClick
  }) => /*#__PURE__*/React.createElement("button", {
    onClick: e => {
      e.stopPropagation();
      onClick();
    },
    style: {
      position: 'absolute',
      top: '50%',
      [dir]: 28,
      transform: 'translateY(-50%)',
      border: 'none',
      background: 'rgba(255,255,255,.08)',
      color: 'rgba(255,255,255,.9)',
      width: 44,
      height: 44,
      borderRadius: 22,
      fontSize: 18,
      cursor: 'pointer',
      display: 'flex',
      alignItems: 'center',
      justifyContent: 'center',
      transition: 'background .15s'
    },
    onMouseEnter: e => e.currentTarget.style.background = 'rgba(255,255,255,.18)',
    onMouseLeave: e => e.currentTarget.style.background = 'rgba(255,255,255,.08)'
  }, /*#__PURE__*/React.createElement("svg", {
    width: "18",
    height: "18",
    viewBox: "0 0 18 18",
    fill: "none",
    stroke: "currentColor",
    strokeWidth: "2",
    strokeLinecap: "round"
  }, /*#__PURE__*/React.createElement("path", {
    d: dir === 'left' ? 'M11 3L5 9l6 6' : 'M7 3l6 6-6 6'
  })));

  // Portal to body so position:fixed is the real viewport regardless of any
  // transform on DesignCanvas's ancestors (including the canvas zoom itself).
  return ReactDOM.createPortal(/*#__PURE__*/React.createElement("div", {
    onClick: () => ctx.setFocus(null),
    onWheel: e => e.preventDefault(),
    style: {
      position: 'fixed',
      inset: 0,
      zIndex: 100,
      background: 'rgba(24,20,16,.6)',
      backdropFilter: 'blur(14px)',
      fontFamily: DC.font,
      color: '#fff'
    }
  }, /*#__PURE__*/React.createElement("div", {
    onClick: e => e.stopPropagation(),
    style: {
      position: 'absolute',
      top: 0,
      left: 0,
      right: 0,
      height: 72,
      display: 'flex',
      alignItems: 'flex-start',
      padding: '16px 20px 0',
      gap: 16
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      position: 'relative'
    }
  }, /*#__PURE__*/React.createElement("button", {
    onClick: () => setDd(o => !o),
    style: {
      border: 'none',
      background: 'transparent',
      color: '#fff',
      cursor: 'pointer',
      padding: '6px 8px',
      borderRadius: 6,
      textAlign: 'left',
      fontFamily: 'inherit'
    }
  }, /*#__PURE__*/React.createElement("span", {
    style: {
      display: 'flex',
      alignItems: 'center',
      gap: 8
    }
  }, /*#__PURE__*/React.createElement("span", {
    style: {
      fontSize: 18,
      fontWeight: 600,
      letterSpacing: -0.3
    }
  }, meta.title), /*#__PURE__*/React.createElement("svg", {
    width: "11",
    height: "11",
    viewBox: "0 0 11 11",
    fill: "none",
    stroke: "currentColor",
    strokeWidth: "1.8",
    strokeLinecap: "round",
    style: {
      opacity: .7
    }
  }, /*#__PURE__*/React.createElement("path", {
    d: "M2 4l3.5 3.5L9 4"
  }))), meta.subtitle && /*#__PURE__*/React.createElement("span", {
    style: {
      display: 'block',
      fontSize: 13,
      opacity: .6,
      fontWeight: 400,
      marginTop: 2
    }
  }, meta.subtitle)), ddOpen && /*#__PURE__*/React.createElement("div", {
    style: {
      position: 'absolute',
      top: '100%',
      left: 0,
      marginTop: 4,
      background: '#2a251f',
      borderRadius: 8,
      boxShadow: '0 8px 32px rgba(0,0,0,.4)',
      padding: 4,
      minWidth: 200,
      zIndex: 10
    }
  }, sectionOrder.filter(sid => sectionMeta[sid].slotIds.length).map(sid => /*#__PURE__*/React.createElement("button", {
    key: sid,
    onClick: () => {
      setDd(false);
      const f = sectionMeta[sid].slotIds[0];
      if (f) ctx.setFocus(`${sid}/${f}`);
    },
    style: {
      display: 'block',
      width: '100%',
      textAlign: 'left',
      border: 'none',
      cursor: 'pointer',
      background: sid === sectionId ? 'rgba(255,255,255,.1)' : 'transparent',
      color: '#fff',
      padding: '8px 12px',
      borderRadius: 5,
      fontSize: 14,
      fontWeight: sid === sectionId ? 600 : 400,
      fontFamily: 'inherit'
    }
  }, sectionMeta[sid].title)))), /*#__PURE__*/React.createElement("div", {
    style: {
      flex: 1
    }
  }), /*#__PURE__*/React.createElement("button", {
    onClick: () => ctx.setFocus(null),
    onMouseEnter: e => e.currentTarget.style.background = 'rgba(255,255,255,.12)',
    onMouseLeave: e => e.currentTarget.style.background = 'transparent',
    style: {
      border: 'none',
      background: 'transparent',
      color: 'rgba(255,255,255,.7)',
      width: 32,
      height: 32,
      borderRadius: 16,
      fontSize: 20,
      cursor: 'pointer',
      lineHeight: 1,
      transition: 'background .12s'
    }
  }, "\xD7")), /*#__PURE__*/React.createElement("div", {
    style: {
      position: 'absolute',
      top: 64,
      bottom: 56,
      left: 100,
      right: 100,
      display: 'flex',
      flexDirection: 'column',
      alignItems: 'center',
      justifyContent: 'center',
      gap: 16
    }
  }, /*#__PURE__*/React.createElement("div", {
    onClick: e => e.stopPropagation(),
    style: {
      width: width * scale,
      height: height * scale,
      position: 'relative'
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      width,
      height,
      transform: `scale(${scale})`,
      transformOrigin: 'top left',
      background: '#fff',
      borderRadius: 2,
      overflow: 'hidden',
      boxShadow: '0 20px 80px rgba(0,0,0,.4)'
    }
  }, children || /*#__PURE__*/React.createElement("div", {
    style: {
      height: '100%',
      display: 'flex',
      alignItems: 'center',
      justifyContent: 'center',
      color: '#bbb'
    }
  }, aid))), /*#__PURE__*/React.createElement("div", {
    onClick: e => e.stopPropagation(),
    style: {
      fontSize: 14,
      fontWeight: 500,
      opacity: .85,
      textAlign: 'center'
    }
  }, (sec.labels || {})[aid] ?? artboard.props.label, /*#__PURE__*/React.createElement("span", {
    style: {
      opacity: .5,
      marginLeft: 10,
      fontVariantNumeric: 'tabular-nums'
    }
  }, idx + 1, " / ", peers.length))), /*#__PURE__*/React.createElement(Arrow, {
    dir: "left",
    onClick: () => go(-1)
  }), /*#__PURE__*/React.createElement(Arrow, {
    dir: "right",
    onClick: () => go(1)
  }), /*#__PURE__*/React.createElement("div", {
    onClick: e => e.stopPropagation(),
    style: {
      position: 'absolute',
      bottom: 20,
      left: '50%',
      transform: 'translateX(-50%)',
      display: 'flex',
      gap: 8
    }
  }, peers.map((p, i) => /*#__PURE__*/React.createElement("button", {
    key: p,
    onClick: () => ctx.setFocus(`${sectionId}/${p}`),
    style: {
      border: 'none',
      padding: 0,
      cursor: 'pointer',
      width: 6,
      height: 6,
      borderRadius: 3,
      background: i === idx ? '#fff' : 'rgba(255,255,255,.3)'
    }
  })))), document.body);
}

// ─────────────────────────────────────────────────────────────
// Post-it — absolute-positioned sticky note
// ─────────────────────────────────────────────────────────────
function DCPostIt({
  children,
  top,
  left,
  right,
  bottom,
  rotate = -2,
  width = 180
}) {
  return /*#__PURE__*/React.createElement("div", {
    style: {
      position: 'absolute',
      top,
      left,
      right,
      bottom,
      width,
      background: DC.postitBg,
      padding: '14px 16px',
      fontFamily: '"Comic Sans MS", "Marker Felt", "Segoe Print", cursive',
      fontSize: 14,
      lineHeight: 1.4,
      color: DC.postitText,
      boxShadow: '0 2px 8px rgba(0,0,0,0.12), 0 1px 2px rgba(0,0,0,0.08)',
      transform: `rotate(${rotate}deg)`,
      zIndex: 5
    }
  }, children);
}
Object.assign(window, {
  DesignCanvas,
  DCSection,
  DCArtboard,
  DCPostIt
});
})(); } catch (e) { __ds_ns.__errors.push({ path: "ui_kits/teacher-panel/design-canvas.jsx", error: String((e && e.message) || e) }); }

})();
