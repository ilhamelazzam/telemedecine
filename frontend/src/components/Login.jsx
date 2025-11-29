import React, { useState } from "react";
import "../styles/auth.css";

export default function Login({ onSubmit, onGoRegister, onGoReset }) {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [errors, setErrors] = useState({});
  const [isLoading, setIsLoading] = useState(false);

  const validateForm = () => {
    const newErrors = {};

    if (!email) {
      newErrors.email = "Email est requis";
    } else if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
      newErrors.email = "Email invalide";
    }

    if (!password) {
      newErrors.password = "Mot de passe est requis";
    } else if (password.length < 6) {
      newErrors.password = "Le mot de passe doit contenir au moins 6 caracteres";
    }

    return newErrors;
  };

  const handleSubmit = async (e) => {
    e.preventDefault();

    const newErrors = validateForm();
    setErrors(newErrors);

    if (Object.keys(newErrors).length === 0) {
      setIsLoading(true);
      try {
        await onSubmit({ email, password });
      } finally {
        setIsLoading(false);
      }
    }
  };

  const fallbackNavigate = (url) => {
    window.location.href = url;
  };

  return (
    <div className="auth-container">
      <div className="auth-card fade-in">
        {/* Header */}
        <div className="auth-header">
          <div className="auth-icon">{"\u{1F3E5}"}</div>
          <h1 className="auth-title">TeleMedecine</h1>
          <p className="auth-subtitle">Connexion a votre compte</p>
        </div>

        {/* Form */}
        <form onSubmit={handleSubmit} className="auth-form">
          {/* Email Field */}
          <div className="form-group">
            <label htmlFor="email" className="form-label">
              Adresse email
            </label>
            <input
              id="email"
              type="email"
              value={email}
              onChange={(e) => {
                setEmail(e.target.value);
                if (errors.email) setErrors({ ...errors, email: "" });
              }}
              className={`form-input ${errors.email ? "input-error" : ""}`}
              placeholder="vous@exemple.com"
            />
            {errors.email && (
              <span className="error-message slide-in">{errors.email}</span>
            )}
          </div>

          {/* Password Field */}
          <div className="form-group">
            <label htmlFor="password" className="form-label">
              Mot de passe
            </label>
            <input
              id="password"
              type="password"
              value={password}
              onChange={(e) => {
                setPassword(e.target.value);
                if (errors.password) setErrors({ ...errors, password: "" });
              }}
              className={`form-input ${errors.password ? "input-error" : ""}`}
              placeholder="********"
            />
            {errors.password && (
              <span className="error-message slide-in">{errors.password}</span>
            )}
          </div>

          {/* Submit Button */}
          <button
            type="submit"
            disabled={isLoading}
            className="btn-primary btn-pulse"
          >
            {isLoading ? "Connexion..." : "Se connecter"}
          </button>
        </form>

        {/* Footer Links */}
        <div className="auth-footer">
          <button
            type="button"
            className="link-secondary"
            onClick={() =>
              onGoReset ? onGoReset() : fallbackNavigate("/reset-password")
            }
          >
            Mot de passe oublié ?
          </button>
          <span className="divider">{"\u2022"}</span>
          <button
            type="button"
            className="link-secondary"
            onClick={() =>
              onGoRegister ? onGoRegister() : fallbackNavigate("/register")
            }
          >
            Créer un compte
          </button>
        </div>
      </div>
    </div>
  );
}
