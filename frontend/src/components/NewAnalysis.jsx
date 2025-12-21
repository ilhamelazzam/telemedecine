"use client"

import { useState } from "react"
import { analysisApi } from "../services/api"

export function NewAnalysis({ onComplete, onCancel }) {
  const [symptoms, setSymptoms] = useState("")
  const [categories, setCategories] = useState([])
  const [imageUrl, setImageUrl] = useState("")
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState(null)

  const availableCategories = [
    "respiratoire",
    "digestif",
    "neurologique",
    "musculaire",
    "fevre",
    "allergique",
  ]

  const toggleCategory = (category) => {
    setCategories((prev) =>
      prev.includes(category) ? prev.filter((c) => c !== category) : [...prev, category]
    )
  }

  const handleSubmit = async (e) => {
    e.preventDefault()

    if (!symptoms.trim()) {
      setError("Veuillez décrire vos symptômes")
      return
    }

    try {
      setLoading(true)
      setError(null)
      const result = await analysisApi.submitAnalysis(
        symptoms, 
        categories, 
        imageUrl || null
      )
      onComplete?.(result)
    } catch (err) {
      setError(err.message)
      console.error("Error submitting analysis:", err)
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="new-analysis fade-in">
      <div className="analysis-container">
        <h2 className="section-title">Nouvelle analyse de symptômes</h2>
        <p className="section-subtitle">Décrivez vos symptômes pour obtenir une analyse IA</p>

        {error && (
          <div className="error-banner">
            <span>⚠️</span>
            <span>{error}</span>
          </div>
        )}

        <form onSubmit={handleSubmit} className="analysis-form">
          {/* Symptoms Description */}
          <div className="form-group">
            <label className="form-label" htmlFor="symptoms">
              Décrivez vos symptômes *
            </label>
            <textarea
              id="symptoms"
              className="form-textarea"
              rows="5"
              placeholder="Ex: J'ai de la fièvre depuis hier, des maux de tête et de la fatigue..."
              value={symptoms}
              onChange={(e) => setSymptoms(e.target.value)}
              disabled={loading}
              required
            />
            <span className="form-hint">
              Soyez aussi précis que possible pour une analyse plus exacte
            </span>
          </div>

          {/* Categories Selection */}
          <div className="form-group">
            <label className="form-label">Catégories de symptômes (optionnel)</label>
            <div className="categories-grid">
              {availableCategories.map((category) => (
                <button
                  key={category}
                  type="button"
                  className={`category-chip ${categories.includes(category) ? "selected" : ""}`}
                  onClick={() => toggleCategory(category)}
                  disabled={loading}
                >
                  {category}
                </button>
              ))}
            </div>
          </div>

          {/* Image URL (Optional) */}
          <div className="form-group">
            <label className="form-label" htmlFor="imageUrl">
              URL d'une image médicale (optionnel)
            </label>
            <input
              id="imageUrl"
              type="url"
              className="form-input"
              placeholder="https://exemple.com/image.jpg"
              value={imageUrl}
              onChange={(e) => setImageUrl(e.target.value)}
              disabled={loading}
            />
            <span className="form-hint">
              Si vous avez une image pertinente (radiographie, photo, etc.)
            </span>
          </div>

          {/* Action Buttons */}
          <div className="form-actions">
            <button
              type="button"
              className="btn-secondary"
              onClick={onCancel}
              disabled={loading}
            >
              Annuler
            </button>
            <button type="submit" className="btn-primary" disabled={loading}>
              {loading ? "Analyse en cours..." : "Analyser mes symptômes"}
            </button>
          </div>
        </form>

        {/* Disclaimer */}
        <div className="disclaimer">
          <p>
            ⚠️ <strong>Avertissement:</strong> Cette analyse est fournie à titre informatif
            uniquement. En cas de symptômes graves ou persistants, consultez un professionnel de
            santé.
          </p>
        </div>
      </div>
    </div>
  )
}

export default NewAnalysis
