import React, { useState } from 'react';
import '../styles/auth.css';

export default function ResetPassword({ onSubmit, onGoLogin }) {
  const [step, setStep] = useState('email'); // 'email' | 'code' | 'newPassword'
  const [email, setEmail] = useState('');
  const [code, setCode] = useState('');
  const [newPassword, setNewPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');
  const [errors, setErrors] = useState({});
  const [isLoading, setIsLoading] = useState(false);
  const [successMessage, setSuccessMessage] = useState('');

  const navigateToLogin = () => {
    if (onGoLogin) {
      onGoLogin();
    } else {
      window.location.href = '/login';
    }
  };

  const validateEmail = () => {
    if (!email) {
      setErrors({ email: 'Email est requis' });
      return false;
    }
    if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
      setErrors({ email: 'Email invalide' });
      return false;
    }
    return true;
  };

  const validateCode = () => {
    if (!code || code.length !== 6) {
      setErrors({ code: 'Code de 6 chiffres requis' });
      return false;
    }
    return true;
  };

  const validatePassword = () => {
    const newErrors = {};
    if (!newPassword) {
      newErrors.newPassword = 'Nouveau mot de passe requis';
    } else if (newPassword.length < 8) {
      newErrors.newPassword = 'Au moins 8 caractères requis';
    } else if (!/[A-Z]/.test(newPassword) || !/[0-9]/.test(newPassword)) {
      newErrors.newPassword = 'Au moins 1 majuscule et 1 chiffre requis';
    }
    
    if (newPassword !== confirmPassword) {
      newErrors.confirmPassword = 'Les mots de passe ne correspondent pas';
    }
    
    setErrors(newErrors);
    return Object.keys(newErrors).length === 0;
  };

  const handleEmailSubmit = async (e) => {
    e.preventDefault();
    if (validateEmail()) {
      setIsLoading(true);
      try {
        await onSubmit({ step: 'email', email });
        setSuccessMessage('Code de vérification envoyé à votre email');
        setTimeout(() => {
          setStep('code');
          setSuccessMessage('');
        }, 1500);
      } finally {
        setIsLoading(false);
      }
    }
  };

  const handleCodeSubmit = async (e) => {
    e.preventDefault();
    if (validateCode()) {
      setIsLoading(true);
      try {
        await onSubmit({ step: 'code', email, code });
        setSuccessMessage('Code vérifié avec succès');
        setTimeout(() => {
          setStep('newPassword');
          setSuccessMessage('');
        }, 1500);
      } finally {
        setIsLoading(false);
      }
    }
  };

  const handlePasswordSubmit = async (e) => {
    e.preventDefault();
    if (validatePassword()) {
      setIsLoading(true);
      try {
        await onSubmit({ step: 'newPassword', email, code, newPassword });
        setSuccessMessage('Mot de passe r?initialis? avec succ??s');
        setTimeout(() => {
          navigateToLogin();
        }, 1500);
      } finally {
        setIsLoading(false);
      }
    }
  };

  return (
    <div className="auth-container">
      <div className="auth-card fade-in">
        {/* Header */}
        <div className="auth-header">
          <div className="auth-icon">🏥</div>
          <h1 className="auth-title">TéleMédecine</h1>
          <p className="auth-subtitle">Réinitialiser votre mot de passe</p>
        </div>

        {/* Success Message */}
        {successMessage && (
          <div className="success-message fade-in">{successMessage}</div>
        )}

        {/* Step 1: Email */}
        {step === 'email' && (
          <form onSubmit={handleEmailSubmit} className="auth-form">
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
                  if (errors.email) setErrors({ email: '' });
                }}
                className={`form-input ${errors.email ? 'input-error' : ''}`}
                placeholder="vous@exemple.com"
              />
              {errors.email && (
                <span className="error-message slide-in">{errors.email}</span>
              )}
            </div>

            <button
              type="submit"
              disabled={isLoading}
              className="btn-primary btn-pulse"
            >
              {isLoading ? 'Envoi...' : 'Envoyer un code'}
            </button>
          </form>
        )}

        {/* Step 2: Code */}
        {step === 'code' && (
          <form onSubmit={handleCodeSubmit} className="auth-form">
            <p className="step-description">
              Un code de vérification a été envoyé à <strong>{email}</strong>
            </p>
            
            <div className="form-group">
              <label htmlFor="code" className="form-label">
                Code de vérification
              </label>
              <input
                id="code"
                type="text"
                maxLength="6"
                value={code}
                onChange={(e) => {
                  setCode(e.target.value.replace(/\D/g, ''));
                  if (errors.code) setErrors({ code: '' });
                }}
                className={`form-input code-input ${errors.code ? 'input-error' : ''}`}
                placeholder="000000"
              />
              {errors.code && (
                <span className="error-message slide-in">{errors.code}</span>
              )}
            </div>

            <button
              type="submit"
              disabled={isLoading}
              className="btn-primary btn-pulse"
            >
              {isLoading ? 'Vérification...' : 'Vérifier le code'}
            </button>

            <button
              type="button"
              onClick={() => setStep('email')}
              className="btn-secondary"
            >
              Retour
            </button>
          </form>
        )}

        {/* Step 3: New Password */}
        {step === 'newPassword' && (
          <form onSubmit={handlePasswordSubmit} className="auth-form">
            <div className="form-group">
              <label htmlFor="newPassword" className="form-label">
                Nouveau mot de passe
              </label>
              <input
                id="newPassword"
                type="password"
                value={newPassword}
                onChange={(e) => {
                  setNewPassword(e.target.value);
                  if (errors.newPassword) setErrors({ ...errors, newPassword: '' });
                }}
                className={`form-input ${errors.newPassword ? 'input-error' : ''}`}
                placeholder="••••••••"
              />
              {errors.newPassword && (
                <span className="error-message slide-in">{errors.newPassword}</span>
              )}
            </div>

            <div className="form-group">
              <label htmlFor="confirmPassword" className="form-label">
                Confirmer mot de passe
              </label>
              <input
                id="confirmPassword"
                type="password"
                value={confirmPassword}
                onChange={(e) => {
                  setConfirmPassword(e.target.value);
                  if (errors.confirmPassword) setErrors({ ...errors, confirmPassword: '' });
                }}
                className={`form-input ${errors.confirmPassword ? 'input-error' : ''}`}
                placeholder="••••••••"
              />
              {errors.confirmPassword && (
                <span className="error-message slide-in">{errors.confirmPassword}</span>
              )}
            </div>

            <button
              type="submit"
              disabled={isLoading}
              className="btn-primary btn-pulse"
            >
              {isLoading ? 'Réinitialisation...' : 'Réinitialiser'}
            </button>
          </form>
        )}

        {/* Footer Links */}
        <div className="auth-footer">
          <button
            type="button"
            className="link-secondary"
            onClick={() => navigateToLogin()}
          >
            Retour ?? la connexion
          </button>
        </div>
      </div>
    </div>
  );
}
