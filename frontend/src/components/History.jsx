"use client"

import { useState } from "react"

export function AnalysisHistory({ onSelectAnalysis, onNewAnalysis }) {
  const [sortBy, setSortBy] = useState("date")

  const [analyses] = useState([
    {
      id: 1,
      date: "21 Nov 2024",
      symptoms: "Toux légère, fatigue",
      severity: "Low",
      icon: "🟢",
    },
    {
      id: 2,
      date: "18 Nov 2024",
      symptoms: "Mal à la gorge, fièvre",
      severity: "Medium",
      icon: "🟡",
    },
    {
      id: 3,
      date: "15 Nov 2024",
      symptoms: "Douleur dorsale, fatigue extrême",
      severity: "High",
      icon: "🔴",
    },
    {
      id: 4,
      date: "10 Nov 2024",
      symptoms: "Légers symptômes de rhume",
      severity: "Low",
      icon: "🟢",
    },
  ])

  const sortedAnalyses = [...analyses].sort((a, b) => {
    if (sortBy === "date") {
      return new Date(b.date) - new Date(a.date)
    } else if (sortBy === "severity") {
      const severityOrder = { High: 3, Medium: 2, Low: 1 }
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
        <div className="analyses-list">
          {sortedAnalyses.map((analysis) => (
            <div key={analysis.id} className="analysis-card" onClick={() => onSelectAnalysis(analysis)}>
              <div className="analysis-icon">{analysis.icon}</div>
              <div className="analysis-info">
                <h4 className="analysis-date">{analysis.date}</h4>
                <p className="analysis-symptoms">{analysis.symptoms}</p>
              </div>
              <div className="analysis-severity">{analysis.severity}</div>
              <span className="arrow">→</span>
            </div>
          ))}
        </div>

        {/* New Analysis Button */}
        <button className="btn-primary btn-large" onClick={onNewAnalysis}>
          + Nouvelle analyse
        </button>
      </div>
    </div>
  )
}

export default AnalysisHistory
