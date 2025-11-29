"use client"

import { useState } from "react"

export function SymptomAnalysis({ onAnalyzeClick, onResultsReady }) {
  const [symptoms, setSymptoms] = useState("")
  const [selectedCategories, setSelectedCategories] = useState([])
  const [imageFile, setImageFile] = useState(null)
  const [loading, setLoading] = useState(false)

  const categories = ["🌡️ Fièvre", "🤧 Toux", "🤕 Douleur", "😴 Fatigue", "🤢 Nausée", "😤 Essoufflement"]

  const handleCategoryToggle = (category) => {
    setSelectedCategories((prev) =>
      prev.includes(category) ? prev.filter((c) => c !== category) : [...prev, category],
    )
  }

  const handleImageUpload = (e) => {
    const file = e.target.files?.[0]
    if (file) {
      setImageFile(file.name)
    }
  }

  const handleAnalyze = async () => {
    if (!symptoms.trim() && selectedCategories.length === 0) {
      alert("Veuillez décrire vos symptômes ou sélectionner une catégorie")
      return
    }

    setLoading(true)
    try {
      // TODO: Appelez votre API d'analyse IA ici
      await new Promise((resolve) => setTimeout(resolve, 1500)) // Simulation

      const analysisData = {
        symptoms,
        categories: selectedCategories,
        image: imageFile,
      }

      console.log("[v0] Analysis data:", analysisData)
      onResultsReady?.(analysisData)
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="symptom-analysis fade-in">
      <div className="analysis-container">
        <h2 className="section-title">Décrivez vos symptômes</h2>
        <p className="section-subtitle">Fournissez autant de détails que possible pour une meilleure analyse</p>

        {/* Symptom Description */}
        <div className="form-group">
          <label className="form-label">Description de vos symptômes</label>
          <textarea
            className="form-textarea"
            placeholder="Ex: Toux depuis 3 jours, mal à la gorge, légère fièvre..."
            value={symptoms}
            onChange={(e) => setSymptoms(e.target.value)}
            rows="5"
          />
        </div>

        {/* Categories */}
        <div className="form-group">
          <label className="form-label">Catégories de symptômes</label>
          <div className="categories-grid">
            {categories.map((category) => (
              <button
                key={category}
                className={`category-btn ${selectedCategories.includes(category) ? "selected" : ""}`}
                onClick={() => handleCategoryToggle(category)}
              >
                {category}
              </button>
            ))}
          </div>
        </div>

        {/* Image Upload */}
        <div className="form-group">
          <label className="form-label">Ajouter une image (optionnel)</label>
          <div className="upload-area">
            <input
              type="file"
              accept="image/*"
              onChange={handleImageUpload}
              style={{ display: "none" }}
              id="image-input"
            />
            <label htmlFor="image-input" className="upload-label">
              {imageFile ? `✓ ${imageFile}` : "📷 Cliquez pour ajouter une image"}
            </label>
          </div>
        </div>

        {/* Analyze Button */}
        <button className="btn-primary btn-large" onClick={handleAnalyze} disabled={loading}>
          {loading ? "⏳ Analyse en cours..." : "🔬 Analyser avec l'IA"}
        </button>
      </div>
    </div>
  )
}

export default SymptomAnalysis
