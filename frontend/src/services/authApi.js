// DEPRECATED: Use src/services/api.js instead
// This file is kept for backward compatibility
import { authApi } from './api';

const API_BASE_URL = "http://localhost:8081/api";

export async function login(email, password) {
  return authApi.login(email, password);
}

export async function register(payload) {
  return authApi.register(payload);
}

export async function requestPasswordReset(email) {
  return authApi.requestPasswordReset(email);
}
