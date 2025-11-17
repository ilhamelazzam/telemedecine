'use client';

import React from 'react';

export default function VerifyIdentityPage({ onGoLogin }) {
  const handleVerify = async (data) => {
    console.log('[v0] Verify identity:', data);
    alert('✅ Identité vérifiée');
    if (onGoLogin) onGoLogin();
  };

  return (
    <div className="min-h-screen flex items-center justify-center bg-gray-50">
      <div className="max-w-md w-full space-y-8 p-8 bg-white rounded-lg shadow">
        <h2 className="text-2xl font-bold text-center">Vérifier votre identité</h2>
        <p className="text-center text-gray-600">Fonctionnalité à implémenter</p>
        <button
          onClick={onGoLogin}
          className="w-full py-2 px-4 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-blue-600 hover:bg-blue-700"
        >
          Retour à la connexion
        </button>
      </div>
    </div>
  );
}