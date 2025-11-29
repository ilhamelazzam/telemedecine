'use client';

import Register from '../components/Register';

export default function RegisterPage({ onGoLogin }) {
  const handleRegisterSubmit = async (data) => {
    console.log('[v0] Register attempt:', data);
    try {
      const payload = {
        fullName: `${data.firstName} ${data.lastName}`.trim(),
        email: data.email,
        password: data.password,
        phone: null,
        address: null,
        region: null
      };

      const res = await fetch('http://localhost:8080/api/auth/register', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(payload)
      });

      if (!res.ok) {
        const txt = await res.text();
        throw new Error(txt || 'Erreur inscription');
      }

      const json = await res.json();
      alert(`Inscription reussie: ${json.email || data.email}`);
      if (onGoLogin) onGoLogin(); else window.location.href = '/login';
    } catch (err) {
      console.error(err);
      alert(err.message || "Erreur lors de l'inscription");
      throw err;
    }
  };

  return (
    <Register onSubmit={handleRegisterSubmit} onGoLogin={onGoLogin} />
  );
}
