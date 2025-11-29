"use client"

import { useState } from "react"

export function AIResults({ analysisData, onSave, onBackClick }) {
  const [saved, setSaved] = useState(false)
  const [loading, setLoading] = useState(false)

  const handleSave = async () => {
    setLoading(true)
    try {
      // TODO: Appelez votre API pour sauvegarder l'analyse
      await new Promise((resolve) => setTimeout(resolve, 800))
      setSaved(true)
      console.log("[v0] Analysis saved:", analysisData)
      onSave?.(analysisData)
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="ai-results fade-in">
      <div className="results-container">
        <div className="results-header">
          <h2>Résultat de l'analyse IA</h2>
          <button className="close-btn" onClick={onBackClick}>
            ✕
          </button>
        </div>

        {/* Alert Banner */}
        {saved && <div className="alert alert-success">✓ Analyse enregistrée dans votre historique</div>}

        {/* Summary Section */}
        <section className="result-section">
          <h3 className="section-title">Résumé de vos symptômes</h3>
          <div className="symptom-summary">
            {analysisData?.categories?.map((cat) => (
              <span key={cat} className="symptom-tag">
                {cat}
              </span>
            ))}
          </div>
        </section>

        {/* Severity Level */}
        <section className="result-section">
          <h3 className="section-title">Niveau de gravité</h3>
          <div className="severity-indicator">
            <div className="severity-meter low">
              <div className="meter-fill"></div>
            </div>
            <span className="severity-label">Léger - Surveillance recommandée</span>
          </div>
        </section>

        {/* Diagnosis */}
        <section className="result-section">
          <h3 className="section-title">Diagnostic préliminaire</h3>
          <div className="diagnosis-box">
            <p>
              Sur la base de vos symptômes, une infection virale bénigne est probable. Cependant, veuillez consulter un
              professionnel de santé pour un diagnostic certain.
            </p>
          </div>
        </section>

        {/* Recommendations */}
        <section className="result-section">
          <h3 className="section-title">Recommandations</h3>
          <ul className="recommendations-list">
            <li>✓ Reposez-vous suffisamment (7-8 heures de sommeil)</li>
            <li>💧 Hydratez-vous régulièrement</li>
            <li>🌡️ Surveillez votre température</li>
            <li>📞 Consultez un médecin si les symptômes s\'aggravent</li>
          </ul>
        </section>

        {/* Caution */}
        <section className="result-section">
          <div className="caution-box">
            <h4>⚠️ Informations importantes</h4>
            <p>
              Cette analyse est fournie à titre informatif seulement et ne remplace pas l'avis d'un professionnel de
              santé qualifié. En cas de doute, consultez immédiatement un médecin ou appelez les services d'urgence.
            </p>
          </div>
        </section>

        {/* Actions */}
        <div className="results-actions">
          <button className="btn-primary" onClick={handleSave} disabled={loading || saved}>
            {loading ? "⏳ Enregistrement..." : saved ? "✓ Enregistré" : "💾 Enregistrer"}
          </button>
          <button className="btn-secondary" onClick={onBackClick}>
            
          </button>
        </div>
      </div>
    </div>
  )
}

export default AIResults
