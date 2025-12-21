"use client"

import { useState, useEffect } from "react"
import { authApi, profileApi } from "../services/api"

export function UserProfile({ onLogout }) {
  const [editMode, setEditMode] = useState(false)
  const [profileData, setProfileData] = useState({
    firstName: "",
    lastName: "",
    email: "",
    phone: "",
    address: "",
    region: "",
  })
  const [formData, setFormData] = useState(profileData)
  const [loading, setLoading] = useState(true)
  const [saving, setSaving] = useState(false)
  const [error, setError] = useState(null)

  useEffect(() => {
    const loadProfile = () => {
      try {
        setLoading(true)
        const user = authApi.getCurrentUser()
        if (user) {
          const userProfile = {
            firstName: user.firstName || "",
            lastName: user.lastName || "",
            email: user.email || "",
            phone: user.phone || "",
            address: user.address || "",
            region: user.region || "",
          }
          setProfileData(userProfile)
          setFormData(userProfile)
        }
      } catch (err) {
        setError(err.message)
        console.error("Error loading profile:", err)
      } finally {
        setLoading(false)
      }
    }

    loadProfile()
  }, [])

  const handleInputChange = (e) => {
    const { name, value } = e.target
    setFormData((prev) => ({ ...prev, [name]: value }))
  }

  const handleSave = async () => {
    try {
      setSaving(true)
      setError(null)
      await profileApi.updateProfile(formData)
      setProfileData(formData)
      setEditMode(false)
      
      // Update localStorage
      const user = authApi.getCurrentUser()
      const updatedUser = { ...user, ...formData }
      localStorage.setItem("user", JSON.stringify(updatedUser))
    } catch (err) {
      setError(err.message)
      authApi.logout()
      onLogout?.()
    }
  }

  if (loading) {
    return (
      <div className="user-profile fade-in">
        <div className="profile-container">
          <p>Chargement du profil...</p>
        </div>
      </div>
    )
  }

  const handleCancel = () => {
    setFormData(profileData)
    setEditMode(false)
  }

  const handleLogout = () => {
    if (confirm("Êtes-vous sûr de vouloir vous déconnecter ?")) {
      // TODO: Appelez votre API de déconnexion ici
      console.log("[v0] Logout")
      onLogout?.()
    }
  }

  return (
    <div className="user-profile fade-in">
      <div className="profile-container">
        <h2 className="section-title">Votre profil</h2>

        {/* Profile Header */}
        <div className="profile-header">
          <div className="avatar-section">
            <div className="avatar">
              <span className="avatar-initial">
                {profileData.firstName.charAt(0).toUpperCase()}
                {profileData.lastName.charAt(0).toUpperCase()}
              </span>
            </div>
            <div className="profile-info">
              <h3>
                {profileData.firstName} {profileData.lastName}
              </h3>
              <p>{profileData.email}</p>
            </div>
          </div>
        </div>

        {/* Profile Form */}
        <div className="profile-form">
          {/* Personal Info */}
          <fieldset className="form-fieldset" disabled={!editMode}>
            <legend>Informations personnelles</legend>

            <div className="form-row">
              <div className="form-group">
                <label className="form-label">Prénom</label>
                <input
                  type="text"
                  name="firstName"
                  value={formData.firstName}
                  onChange={handleInputChange}
                  className="form-input"
                />
              </div>
              <div className="form-group">
                <label className="form-label">Nom</label>
                <input
                  type="text"
                  name="lastName"
                  value={formData.lastName}
                  onChange={handleInputChange}
                  className="form-input"
                />
              </div>
            </div>

            <div className="form-group">
              <label className="form-label">Email</label>
              <input
                type="email"
                name="email"
                value={formData.email}
                onChange={handleInputChange}
                className="form-input"
              />
            </div>

            <div className="form-group">
              <label className="form-label">Téléphone</label>
              <input
                type="tel"
                name="phone"
                value={formData.phone}
                onChange={handleInputChange}
                className="form-input"
              />
            </div>
          </fieldset>

          {/* Medical Info */}
          <fieldset className="form-fieldset" disabled={!editMode}>
            <legend>Informations médicales (optionnel)</legend>

            <div className="form-group">
              <label className="form-label">Maladies chroniques</label>
              <input
                type="text"
                name="chronicDiseases"
                value={formData.chronicDiseases}
                onChange={handleInputChange}
                className="form-input"
                placeholder="Ex: Asthme, Diabète..."
              />
            </div>

            <div className="form-group">
              <label className="form-label">Allergies</label>
              <input
                type="text"
                name="allergies"
                value={formData.allergies}
                onChange={handleInputChange}
                className="form-input"
                placeholder="Ex: Pénicilline, Arachides..."
              />
            </div>

            <div className="form-group">
              <label className="form-label">Langue préférée</label>
              <select name="language" value={formData.language} onChange={handleInputChange} className="form-input">
                <option value="fr">Français</option>
                <option value="en">English</option>
                <option value="es">Español</option>
              </select>
            </div>
          </fieldset>
        </div>

        {/* Actions */}
        <div className="profile-actions">
          {!editMode ? (
            <>
              <button className="btn-primary" onClick={() => setEditMode(true)}>
                ✎ Modifier mon profil
              </button>
              <button className="btn-secondary" onClick={handleLogout}>
                🚪 Déconnexion
              </button>
            </>
          ) : (
            <>
              <button className="btn-primary" onClick={handleSave}>
                ✓ Enregistrer
              </button>
              <button className="btn-secondary" onClick={handleCancel}>
                ✕ Annuler
              </button>
            </>
          )}
        </div>
      </div>
    </div>
  )
}

export default UserProfile
