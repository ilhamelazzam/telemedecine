import AsyncStorage from '@react-native-async-storage/async-storage';
import { patients } from '../data/mockData';

const STORAGE_KEY = 'treatments_state_v1';

export type Treatment = {
  id: string;
  patientId?: string;
  patientName?: string;
  analysisId?: string;
  description?: string;
  validated?: boolean;
  doctor?: string;
  validatedAt?: string;
};

let listeners: Array<() => void> = [];

const defaultTreatments: Treatment[] = (patients || []).map((p: any, idx: number) => ({
  id: `t${idx + 1}`,
  patientId: p.id,
  patientName: p.name,
  description: `Proposed treatment for ${p.name}`,
  validated: false,
}));

async function load(): Promise<Treatment[]> {
  try {
    const raw = await AsyncStorage.getItem(STORAGE_KEY);
    if (!raw) return defaultTreatments;
    const parsed = JSON.parse(raw) as Treatment[];
    // merge defaults for missing
    return parsed;
  } catch (e) {
    return defaultTreatments;
  }
}

async function save(list: Treatment[]) {
  try {
    await AsyncStorage.setItem(STORAGE_KEY, JSON.stringify(list));
  } catch (e) {
    // ignore
  }
}

export async function getTreatments(): Promise<Treatment[]> {
  return load();
}

export async function validateTreatment(id: string, doctor?: string) {
  const list = await load();
  const idx = list.findIndex((t) => t.id === id);
  if (idx === -1) return null;
  list[idx] = { ...list[idx], validated: true, doctor, validatedAt: new Date().toISOString() };
  await save(list);
  listeners.forEach((l) => l());
  return list[idx];
}

export function subscribe(fn: () => void) {
  listeners.push(fn);
  return () => {
    listeners = listeners.filter((l) => l !== fn);
  };
}

export async function resetTreatments() {
  await AsyncStorage.removeItem(STORAGE_KEY);
  listeners.forEach((l) => l());
}

export default { getTreatments, validateTreatment, subscribe, resetTreatments };
