import React, { useState } from 'react';
import '../styles/auth.css';

export default function VerifyCode({ onSubmit, onBack }) {
  const [form, setForm] = useState({ email: '', code: '', newPassword: '' });
  const [errors, setErrors] = useState({});
  const [isLoading, setIsLoading] = useState(false);

  const handleChange = (e) => setForm({ ...form, [e.target.name]: e.target.value });

  const handleSubmit = async (e) => {
    e.preventDefault();
    const errs = {};
    if (!form.email) errs.email = 'Email requis';
    if (!form.code) errs.code = 'Code requis';
    if (!form.newPassword || form.newPassword.length < 8) errs.newPassword = '8 caracteres minimum';
    setErrors(errs);
    if (Object.keys(errs).length === 0 && onSubmit) {
      setIsLoading(true);
      try {
        await onSubmit(form);
      } finally {
        setIsLoading(false);
      }
    }
  };

  return (
    <div className="auth-container">
      <div className="auth-card fade-in">
        <div className="auth-header">
          <div className="auth-icon">🔐</div>
          <h1 className="auth-title">Verifier le code</h1>
          <p className="auth-subtitle">Saisis le code recu par email</p>
        </div>
        <form onSubmit={handleSubmit} className="auth-form">
          <div className="form-group">
            <label className="form-label">Adresse email</label>
            <input
              name="email"
              type="email"
              value={form.email}
              onChange={handleChange}
              className={`form-input ${errors.email ? 'input-error' : ''}`}
              placeholder="vous@exemple.com"
            />
            {errors.email && <span className="error-message slide-in">{errors.email}</span>}
          </div>
          <div className="form-group">
            <label className="form-label">Code de verification</label>
            <input
              name="code"
              type="text"
              value={form.code}
              onChange={handleChange}
              className={`form-input ${errors.code ? 'input-error' : ''}`}
              placeholder="123456"
            />
            {errors.code && <span className="error-message slide-in">{errors.code}</span>}
          </div>
          <div className="form-group">
            <label className="form-label">Nouveau mot de passe</label>
            <input
              name="newPassword"
              type="password"
              value={form.newPassword}
              onChange={handleChange}
              className={`form-input ${errors.newPassword ? 'input-error' : ''}`}
              placeholder="********"
            />
            {errors.newPassword && <span className="error-message slide-in">{errors.newPassword}</span>}
          </div>
          <button type="submit" className="btn-primary btn-pulse" disabled={isLoading}>
            {isLoading ? 'Validation...' : 'Valider et reinitialiser'}
          </button>
        </form>
        <div className="auth-footer">
          <button type="button" className="link-secondary" onClick={onBack}>
            
          </button>
        </div>
      </div>
    </div>
  );
}
