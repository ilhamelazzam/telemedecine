import * as React from 'react';
import { View, StyleSheet, Alert } from 'react-native';
import { TextInput, Button, Title, Card, Paragraph, Checkbox } from 'react-native-paper';
import { useState } from 'react';

const symptomList = [
  'fever',
  'cough',
  'fatigue',
  'headache',
  'sore throat',
  'loss of smell',
  'nausea',
];

// naive mapping symptoms -> possible conditions
const DIAGNOSIS_MAP: Record<string, string[]> = {
  fever: ['Viral infection', 'Flu'],
  cough: ['Common cold', 'Bronchitis'],
  'loss of smell': ['COVID-19', 'Sinusitis'],
  nausea: ['Gastroenteritis'],
};

export default function NewAnalysisScreen() {
  const [selected, setSelected] = useState<Record<string, boolean>>({});
  const [notes, setNotes] = useState('');
  const [result, setResult] = useState<string | null>(null);

  const toggle = (s: string) => {
    setSelected((p) => ({ ...p, [s]: !p[s] }));
  };

  const runDiagnosis = () => {
    const picked = Object.keys(selected).filter((k) => selected[k]);
    if (picked.length === 0) {
      Alert.alert('No symptoms', 'Please select at least one symptom');
      return;
    }

    const possible: Record<string, number> = {};
    picked.forEach((s) => {
      const targets = DIAGNOSIS_MAP[s] || ['General infection'];
      targets.forEach((t) => (possible[t] = (possible[t] || 0) + 1));
    });

    const sorted = Object.entries(possible).sort((a, b) => b[1] - a[1]);
    const top = sorted.slice(0, 3).map((r) => r[0]);
    setResult(`Possible: ${top.join(', ')}`);
  };

  return (
    <View style={[styles.container, { backgroundColor: '#f9f5ff' }]}>
      <Title style={styles.title}>Symptom-Based Check</Title>

      <Card style={styles.card}>
        <Card.Content>
          <Paragraph>Select symptoms (check those that apply):</Paragraph>
        </Card.Content>
        {symptomList.map((s) => (
          <Card.Content key={s} style={styles.symptomRow}>
            <Checkbox.Android status={selected[s] ? 'checked' : 'unchecked'} onPress={() => toggle(s)} />
            <Paragraph style={{ marginLeft: 8 }}>{s}</Paragraph>
          </Card.Content>
        ))}
      </Card>

      <TextInput label="Additional notes" mode="outlined" value={notes} onChangeText={setNotes} multiline style={{ marginTop: 12 }} />

      <Button mode="contained" onPress={runDiagnosis} style={{ marginTop: 12 }}>
        Run quick check
      </Button>

      {result && (
        <Card style={{ marginTop: 12 }}>
          <Card.Content>
            <Paragraph>{result}</Paragraph>
          </Card.Content>
        </Card>
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, padding: 12 },
  title: { marginBottom: 8 },
  card: { paddingVertical: 6 },
  symptomRow: { flexDirection: 'row', alignItems: 'center' },
});
