// src/services/authApi.js
const API_BASE_URL = "http://localhost:4000"; // adapte le port/URL selon ton projet v0

export async function login(email, password) {
  const response = await fetch(`${API_BASE_URL}/auth/login`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ email, password }),
  });

  if (!response.ok) {
    const err = await response.json().catch(() => ({}));
    throw new Error(err.message || "Échec de la connexion");
  }

  const data = await response.json();
  // par ex. { token, user }
  localStorage.setItem("token", data.token);
  return data;
}

export async function register(payload) {
  const response = await fetch(`${API_BASE_URL}/auth/register`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(payload),
  });

  if (!response.ok) {
    const err = await response.json().catch(() => ({}));
    throw new Error(err.message || "Échec de l'inscription");
  }

  return response.json();
}

export async function requestPasswordReset(email) {
  const response = await fetch(`${API_BASE_URL}/auth/reset-password`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ email }),
  });

  if (!response.ok) {
    const err = await response.json().catch(() => ({}));
    throw new Error(err.message || "Échec de la demande de réinitialisation");
  }

  return response.json();
}
