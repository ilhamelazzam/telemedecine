"use client"

import { useState, useEffect } from "react"
import { analysisApi } from "../services/api"

export function AnalysisHistory({ onSelectAnalysis, onNewAnalysis }) {
  const [sortBy, setSortBy] = useState("date")
  const [analyses, setAnalyses] = useState([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState(null)

  useEffect(() => {
    const fetchHistory = async () => {
      try {
        setLoading(true)
        const history = await analysisApi.getHistory()
        setAnalyses(history || [])
      } catch (err) {
        setError(err.message)
        console.error("Error fetching history:", err)
      } finally {
        setLoading(false)
      }
    }

    fetchHistory()
  }, [])

  const getSeverityIcon = (severity) => {
    switch (severity?.toLowerCase()) {
      case "high":
        return "🔴"
      case "medium":
        return "🟡"
      case "low":
        return "🟢"
      default:
        return "⚪"
    }
  }

  const sortedAnalyses = [...analyses].sort((a, b) => {
    if (sortBy === "date") {
      return new Date(b.performedAt) - new Date(a.performedAt)
    } else if (sortBy === "severity") {
      const severityOrder = { HIGH: 3, MEDIUM: 2, LOW: 1 }
      return severityOrder[b.severity] - severityOrder[a.severity]
    }
    return 0
  })

  return (
    <div className="analysis-history fade-in">
      <div className="history-container">
        <h2 className="section-title">Historique de vos analyses</h2>
        <p className="section-subtitle">Consultez toutes vos analyses précédentes</p>

        {/* Sort Controls */}
        <div className="history-controls">
          <label>Trier par:</label>
          <select className="sort-select" value={sortBy} onChange={(e) => setSortBy(e.target.value)}>
            <option value="date">Date (plus récente)</option>
            <option value="severity">Gravité</option>
          </select>
        </div>

        {/* Analyses List */}
        {loading ? (
          <div className="analyses-list">
            <p>Chargement de l'historique...</p>
          </div>
        ) : error ? (
          <div className="analyses-list">
            <p className="error-message">Erreur: {error}</p>
          </div>
        ) : analyses.length === 0 ? (
          <div className="analyses-list">
            <p>Aucune analyse disponible. Commencez par faire une nouvelle analyse!</p>
          </div>
        ) : (
          <div className="analyses-list">
            {sortedAnalyses.map((analysis) => (
              <div key={analysis.id} className="analysis-card" onClick={() => onSelectAnalysis(analysis)}>
                <div className="analysis-icon">{getSeverityIcon(analysis.severity)}</div>
                <div className="analysis-info">
                  <h4 className="analysis-date">{new Date(analysis.performedAt).toLocaleDateString('fr-FR', { 
                    day: 'numeric', 
                    month: 'short', 
                    year: 'numeric' 
                  })}</h4>
                  <p className="analysis-symptoms">{analysis.symptoms}</p>
                </div>
                <div className="analysis-severity">{analysis.severity}</div>
                <span className="arrow">→</span>
              </div>
            ))}
          </div>
        )}

        {/* New Analysis Button */}
        <button className="btn-primary btn-large" onClick={onNewAnalysis}>
          + Nouvelle analyse
        </button>
      </div>
    </div>
  )
}

export default AnalysisHistory
