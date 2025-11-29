"use client"

import { useState } from "react"
import "../styles/patient.css"

export function PatientNavigation({ currentScreen, onScreenChange, userName, children }) {
  const [sidebarOpen, setSidebarOpen] = useState(false)

  const screens = [
    { id: "dashboard", label: "Accueil", icon: "🏠" },
    { id: "analysis", label: "Nouvelle analyse", icon: "🔍" },
    { id: "history", label: "Historique", icon: "📋" },
    { id: "notifications", label: "Notifications", icon: "🔔" },
    { id: "profile", label: "Profil", icon: "👤" },
  ]

  const handleLogout = () => {
    if (confirm("Êtes-vous sûr de vouloir vous déconnecter ?")) {
      localStorage.removeItem("authToken")
      window.location.href = "/"
    }
  }

  return (
    <div className="patient-layout">
      <header className="patient-header">
        <div className="header-left">
          <button className="sidebar-toggle" onClick={() => setSidebarOpen(!sidebarOpen)} aria-label="Toggle sidebar">
            ☰
          </button>
          <h1 className="header-logo">TéléMédecine</h1>
        </div>
        <div className="header-right">
          <span className="user-greeting">Bienvenue, {userName || "Utilisateur"}</span>
          <button className="logout-btn" onClick={handleLogout} title="Déconnexion">
            ⊗
          </button>
        </div>
      </header>

      <nav className={`patient-sidebar ${sidebarOpen ? "open" : ""}`}>
        <ul className="nav-list">
          {screens.map((screen) => (
            <li key={screen.id}>
              <button
                className={`nav-link ${currentScreen === screen.id ? "active" : ""}`}
                onClick={() => {
                  onScreenChange(screen.id)
                  setSidebarOpen(false)
                }}
              >
                <span className="nav-icon">{screen.icon}</span>
                <span className="nav-label">{screen.label}</span>
              </button>
            </li>
          ))}
        </ul>
      </nav>

      <main className="patient-main">
        {sidebarOpen && <div className="sidebar-overlay" onClick={() => setSidebarOpen(false)} role="presentation" />}
        {children}
      </main>
    </div>
  )
}

export default PatientNavigation
