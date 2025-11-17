import React, { useState } from 'react';
import Login from '../components/Login';

export default function Home() {
  const handleLoginSubmit = async (credentials) => {
    console.log('Login attempt:', credentials);
    // Simuler un délai API
    await new Promise(resolve => setTimeout(resolve, 1000));
    alert(`Connexion réussie: ${credentials.email}`);
  };

  return <Login onSubmit={handleLoginSubmit} />;
}
