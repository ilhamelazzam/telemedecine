// API Service for Backend Communication
const API_BASE_URL = "http://localhost:8081/api";

// Helper function to get token from localStorage
const getToken = () => localStorage.getItem("token");

// Helper function to handle API responses
const handleResponse = async (response) => {
  if (!response.ok) {
    const error = await response.json().catch(() => ({}));
    throw new Error(error.message || `HTTP Error: ${response.status}`);
  }
  return response.json();
};

// Auth API
export const authApi = {
  login: async (email, password) => {
    const response = await fetch(`${API_BASE_URL}/auth/login`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ email, password }),
    });
    const data = await handleResponse(response);
    if (data.token) {
      localStorage.setItem("token", data.token);
      localStorage.setItem("user", JSON.stringify(data));
    }
    return data;
  },

  register: async (userData) => {
    const response = await fetch(`${API_BASE_URL}/auth/register`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(userData),
    });
    const data = await handleResponse(response);
    if (data.token) {
      localStorage.setItem("token", data.token);
      localStorage.setItem("user", JSON.stringify(data));
    }
    return data;
  },

  requestPasswordReset: async (email) => {
    const response = await fetch(`${API_BASE_URL}/auth/reset-request`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ email }),
    });
    return handleResponse(response);
  },

  verifyCode: async (email, code) => {
    const response = await fetch(`${API_BASE_URL}/auth/verify-code`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ email, code }),
    });
    return handleResponse(response);
  },

  resetPassword: async (email, code, newPassword) => {
    const response = await fetch(`${API_BASE_URL}/auth/reset-password`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ email, code, newPassword }),
    });
    return handleResponse(response);
  },

  logout: () => {
    localStorage.removeItem("token");
    localStorage.removeItem("user");
  },

  getCurrentUser: () => {
    const user = localStorage.getItem("user");
    return user ? JSON.parse(user) : null;
  },

  isAuthenticated: () => {
    return !!getToken();
  },
};

// Analysis API
export const analysisApi = {
  submitAnalysis: async (symptoms, categories, imageUrl = null) => {
    const token = getToken();
    if (!token) throw new Error("Non authentifié");

    const response = await fetch(`${API_BASE_URL}/analysis`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${token}`,
      },
      body: JSON.stringify({ symptoms, categories, imageUrl }),
    });
    return handleResponse(response);
  },

  getHistory: async () => {
    const token = getToken();
    if (!token) throw new Error("Non authentifié");

    const response = await fetch(`${API_BASE_URL}/analysis/history`, {
      method: "GET",
      headers: {
        Authorization: `Bearer ${token}`,
      },
    });
    return handleResponse(response);
  },

  getAnalysisById: async (id) => {
    const token = getToken();
    if (!token) throw new Error("Non authentifié");

    const response = await fetch(`${API_BASE_URL}/analysis/${id}`, {
      method: "GET",
      headers: {
        Authorization: `Bearer ${token}`,
      },
    });
    return handleResponse(response);
  },
};

// Profile API
export const profileApi = {
  getProfile: async () => {
    const token = getToken();
    if (!token) throw new Error("Non authentifié");

    const response = await fetch(`${API_BASE_URL}/profile`, {
      method: "GET",
      headers: {
        Authorization: `Bearer ${token}`,
      },
    });
    return handleResponse(response);
  },

  updateProfile: async (profileData) => {
    const token = getToken();
    if (!token) throw new Error("Non authentifié");

    const response = await fetch(`${API_BASE_URL}/profile`, {
      method: "PUT",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${token}`,
      },
      body: JSON.stringify(profileData),
    });
    return handleResponse(response);
  },
};

// Health Check API
export const healthApi = {
  checkHealth: async () => {
    const response = await fetch(`${API_BASE_URL}/health`, {
      method: "GET",
    });
    return handleResponse(response);
  },
};

export default {
  auth: authApi,
  analysis: analysisApi,
  profile: profileApi,
  health: healthApi,
};
