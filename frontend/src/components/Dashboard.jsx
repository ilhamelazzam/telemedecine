"use client"

import { useState, useEffect } from "react"
import { analysisApi } from "../services/api"

export function PatientDashboard({ onAnalysisClick, onHistoryClick }) {
  const [lastAnalysis, setLastAnalysis] = useState(null)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState(null)

  const [notifications] = useState([
    { id: 1, type: "info", message: "Rappel: Buvez de l'eau régulièrement", read: false },
    { id: 2, type: "alert", message: "Surveillez votre température", read: false },
    { id: 3, type: "info", message: "Analyse précédente mise à jour", read: true },
  ])

  const unreadCount = notifications.filter((n) => !n.read).length

  useEffect(() => {
    const fetchLastAnalysis = async () => {
      try {
        setLoading(true)
        const history = await analysisApi.getHistory()
        if (history && history.length > 0) {
          setLastAnalysis(history[0])
        }
      } catch (err) {
        setError(err.message)
        console.error("Error fetching last analysis:", err)
      } finally {
        setLoading(false)
      }
    }

    fetchLastAnalysis()
  }, [])

  return (
    <div className="patient-dashboard fade-in">
      {/* Welcome Section */}
      <section className="dashboard-section">
        <h2 className="section-title">Bienvenue sur votre espace santé</h2>
        <p className="section-subtitle">Suivez votre santé avec l'aide de l'intelligence artificielle</p>
      </section>

      {/* Last Analysis Card */}
      <section className="dashboard-section">
        {loading ? (
          <div className="card-container">
            <p>Chargement...</p>
          </div>
        ) : error ? (
          <div className="card-container">
            <p className="error-message">Erreur: {error}</p>
          </div>
        ) : lastAnalysis ? (
          <div className="card-container">
            <div className="card-header">
              <h3>Dernière analyse IA</h3>
              <span className={`severity-badge severity-${lastAnalysis.severity.toLowerCase()}`}>
                {lastAnalysis.severity}
              </span>
            </div>
            <div className="card-body">
              <div className="analysis-item">
                <span className="label">Date:</span>
                <span className="value">{new Date(lastAnalysis.performedAt).toLocaleDateString('fr-FR')}</span>
              </div>
              <div className="analysis-item">
                <span className="label">Symptômes:</span>
                <span className="value">{lastAnalysis.symptoms}</span>
              </div>
              <div className="analysis-item">
                <span className="label">Diagnostic:</span>
                <span className="value">{lastAnalysis.diagnosis}</span>
              </div>
            </div>
            <button className="btn-secondary" onClick={onHistoryClick}>
              Voir l'historique complet
            </button>
          </div>
        ) : (
          <div className="card-container">
            <p>Aucune analyse disponible. Commencez par faire une nouvelle analyse!</p>
            <button className="btn-primary" onClick={onAnalysisClick}>
              Faire une analyse
            </button>
          </div>
        )}
      </section>

      {/* Action Section */}
      <section className="dashboard-section">
        <button className="btn-primary btn-large" onClick={onAnalysisClick}>
          📊 Faire une nouvelle analyse
        </button>
      </section>

      {/* Notifications Preview */}
      <section className="dashboard-section">
        <div className="notifications-preview">
          <div className="notifications-header">
            <h3>Notifications récentes</h3>
            {unreadCount > 0 && <span className="badge">{unreadCount}</span>}
          </div>
          <ul className="notifications-list">
            {notifications.slice(0, 3).map((notif) => (
              <li key={notif.id} className={`notification-item ${notif.read ? "read" : "unread"}`}>
                <span className={`notif-icon notif-${notif.type}`}>{notif.type === "info" ? "ℹ️" : "⚠️"}</span>
                <span className="notif-text">{notif.message}</span>
              </li>
            ))}
          </ul>
        </div>
      </section>
    </div>
  )
}

export default PatientDashboard
