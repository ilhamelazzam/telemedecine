'use client';

import Register from '../components/Register';

export default function RegisterPage({ onGoLogin }) {
  const handleRegisterSubmit = async (data) => {
    console.log('[v0] Register attempt:', data);
    // TODO: Appelez votre API d'inscription ici
    // Exemple: const response = await fetch('/api/register', { method: 'POST', body: JSON.stringify(data) })
    alert(`✅ Compte créé: ${data.email}`);
  };

  return (
    <Register onSubmit={handleRegisterSubmit} onGoLogin={onGoLogin} />
  );
}
