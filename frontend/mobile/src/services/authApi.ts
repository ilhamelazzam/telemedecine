import axios from 'axios';
import AsyncStorage from '@react-native-async-storage/async-storage';
import { API_URL, USE_API } from '../config';

const instance = axios.create({ baseURL: API_URL });

const TOKEN_KEY = 'auth_token';

export async function saveToken(token: string) {
  await AsyncStorage.setItem(TOKEN_KEY, token);
  instance.defaults.headers.common.Authorization = `Bearer ${token}`;
}

export async function getToken(): Promise<string | null> {
  return AsyncStorage.getItem(TOKEN_KEY);
}

export async function removeToken() {
  await AsyncStorage.removeItem(TOKEN_KEY);
  delete instance.defaults.headers.common.Authorization;
}

// Local demo credentials (when USE_API is false)
const LOCAL_EMAIL = 'demo@demo.com';
const LOCAL_PASSWORD = 'demo123';

export async function login(email: string, password: string) {
  if (!USE_API) {
    // Only accept the demo credential in local mode
    if (email === LOCAL_EMAIL && password === LOCAL_PASSWORD) {
      const token = 'LOCAL_FAKE_TOKEN_DEMO';
      await saveToken(token);
      return { token };
    }
    // otherwise reject
    throw new Error('Invalid demo credentials. Use demo@demo.com / demo123');
  }

  const resp = await instance.post('/auth/login', { email, password });
  const token = resp.data?.token;
  if (token) await saveToken(token);
  return resp.data;
}

export async function register(payload: { name?: string; email: string; password: string }) {
  if (!USE_API) {
    // In local mode, pretend registration succeeded
    return { success: true, message: 'Registered locally' };
  }
  const resp = await instance.post('/auth/register', payload);
  return resp.data;
}

export default instance;
