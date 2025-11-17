'use client';

import ResetPassword from '../components/ResetPassword';

export default function ResetPasswordPage({ onGoLogin }) {
  const handleResetSubmit = async (data) => {
    console.log('[v0] Reset password:', data);
    // TODO: Appelez votre API de réinitialisation ici
    // Exemple: const response = await fetch('/api/reset-password', { method: 'POST', body: JSON.stringify(data) })
    alert(`✅ Étape ${data.step} traitée`);
  };

  return (
    <ResetPassword onSubmit={handleResetSubmit} onGoLogin={onGoLogin} />
  );
}
