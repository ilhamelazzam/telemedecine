import AsyncStorage from '@react-native-async-storage/async-storage';

const KEY = 'user_profile_v1';

type UserProfile = {
  role?: 'patient' | 'doctor';
  name?: string;
};

export async function saveUser(profile: UserProfile) {
  try {
    await AsyncStorage.setItem(KEY, JSON.stringify(profile));
  } catch (e) {}
}

export async function getUser(): Promise<UserProfile> {
  try {
    const raw = await AsyncStorage.getItem(KEY);
    if (!raw) return {};
    return JSON.parse(raw);
  } catch (e) {
    return {};
  }
}

export async function clearUser() {
  try {
    await AsyncStorage.removeItem(KEY);
  } catch (e) {}
}

export default { saveUser, getUser, clearUser };
