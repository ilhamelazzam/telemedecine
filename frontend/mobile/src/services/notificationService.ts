import AsyncStorage from '@react-native-async-storage/async-storage';
import { notifications as baseNotifications } from '../data/mockData';

const STORAGE_KEY = 'notifications_state_v1';

type NotificationItem = { id: string; text: string; date?: string; read?: boolean };

let listeners: Array<() => void> = [];

async function loadState(): Promise<Record<string, boolean>> {
  try {
    const raw = await AsyncStorage.getItem(STORAGE_KEY);
    if (!raw) return {};
    return JSON.parse(raw);
  } catch (e) {
    return {};
  }
}

async function saveState(map: Record<string, boolean>) {
  try {
    await AsyncStorage.setItem(STORAGE_KEY, JSON.stringify(map));
  } catch (e) {
    // ignore
  }
}

export async function getNotifications(): Promise<NotificationItem[]> {
  const map = await loadState();
  return (baseNotifications || []).map((n: any) => ({ ...n, read: !!map[n.id] }));
}

export async function markAsRead(id: string) {
  const map = await loadState();
  if (map[id]) return; // already read
  map[id] = true;
  await saveState(map);
  listeners.forEach((l) => l());
}

export async function getUnreadCount(): Promise<number> {
  const arr = await getNotifications();
  return arr.filter((n) => !n.read).length;
}

export function subscribe(fn: () => void) {
  listeners.push(fn);
  return () => {
    listeners = listeners.filter((l) => l !== fn);
  };
}

export async function resetNotifications() {
  await AsyncStorage.removeItem(STORAGE_KEY);
  listeners.forEach((l) => l());
}

export default { getNotifications, markAsRead, getUnreadCount, subscribe, resetNotifications };
