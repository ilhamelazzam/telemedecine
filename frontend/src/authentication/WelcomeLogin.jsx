'use client';

import Login from '../components/Login';

export default function LoginPage({ onGoRegister, onGoReset, onLoginSuccess }) {
  const handleLoginSubmit = async (credentials) => {
    console.log('[v0] Login attempt:', credentials);
    try {
      const res = await fetch('http://localhost:8080/api/auth/login', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(credentials)
      });

      if (!res.ok) {
        const txt = await res.text();
        throw new Error(txt || 'Echec de connexion');
      }

      const json = await res.json();
      alert(`Connexion reussie: ${json.email || credentials.email}`);
      if (onLoginSuccess) {
        onLoginSuccess(json);
      }
    } catch (err) {
      console.error(err);
      alert(err.message || 'Erreur lors de la connexion');
      throw err;
    }
  };

  return (
    <Login
      onSubmit={handleLoginSubmit}
      onGoRegister={onGoRegister}
      onGoReset={onGoReset}
    />
  );
}
