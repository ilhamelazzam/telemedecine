'use client';

import ResetPassword from '../components/ResetPassword';

export default function ResetPasswordPage({ onGoLogin }) {
  const handleResetSubmit = async (data) => {
    // data: { step, email, code, newPassword }
    try {
      if (data.step === 'email') {
        const res = await fetch('http://localhost:8080/api/auth/reset-request', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ email: data.email })
        });
        const txt = await res.text();
        if (!res.ok) {
          throw new Error(txt || 'Erreur envoi code');
        }
        console.log('reset-request response:', txt);
        return txt; // renvoyer le corps pour pouvoir afficher le code en dev
      } else if (data.step === 'code') {
        const res = await fetch('http://localhost:8080/api/auth/verify-code', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ email: data.email, code: data.code })
        });
        if (!res.ok) {
          const txt = await res.text();
          throw new Error(txt || 'Code invalide');
        }
      } else if (data.step === 'newPassword') {
        const res = await fetch('http://localhost:8080/api/auth/reset-password', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ email: data.email, code: data.code, newPassword: data.newPassword })
        });
        if (!res.ok) {
          const txt = await res.text();
          throw new Error(txt || 'Erreur reinitialisation');
        }
      }
    } catch (err) {
      console.error(err);
      alert(err.message || 'Erreur');
      throw err; // rethrow so the component knows the call failed
    }
  };

  return (
    <ResetPassword onSubmit={handleResetSubmit} onGoLogin={onGoLogin} />
  );
}
