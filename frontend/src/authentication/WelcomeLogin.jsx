'use client';

import Login from '../components/Login';

export default function LoginPage({ onGoRegister, onGoReset }) {
  const handleLoginSubmit = async (credentials) => {
    console.log('[v0] Login attempt:', credentials);
    // TODO: Appelez votre API d'authentification ici
    // Exemple: const response = await fetch('/api/login', { method: 'POST', body: JSON.stringify(credentials) })
    alert(`�o. Connexion rǸussie: ${credentials.email}`);
  };

  return (
    <Login
      onSubmit={handleLoginSubmit}
      onGoRegister={onGoRegister}
      onGoReset={onGoReset}
    />
  );
}
