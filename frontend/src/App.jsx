// src/App.jsx
import React, { useState } from "react";
import WelcomeLogin from "./authentication/WelcomeLogin.jsx";
import RegisterPatient from "./authentication/RegisterPatient.jsx";
import ResetPassword from "./authentication/ResetPassword.jsx";
import VerifyIdentity from "./authentication/VerifyIdentity.jsx";
import PatientPage from "./patient.jsx";

function App() {
  const [screen, setScreen] = useState("login");

  const goToLogin = () => setScreen("login");
  const goToRegister = () => setScreen("register");
  const goToReset = () => setScreen("reset");
  const goToVerify = () => setScreen("verify");
  const goToDashboard = () => setScreen("patient");

  if (screen === "register") {
    return <RegisterPatient onGoLogin={goToLogin} />;
  }

  if (screen === "reset") {
    return <ResetPassword onGoLogin={goToLogin} />;
  }

  if (screen === "verify") {
    return <VerifyIdentity onGoLogin={goToLogin} />;
  }

  if (screen === "patient") {
    return <PatientPage />;
  }

  // écran par défaut : login
  return (
    <WelcomeLogin onGoRegister={goToRegister} onGoReset={goToReset} onLoginSuccess={goToDashboard} />
  );
}

export default App;
