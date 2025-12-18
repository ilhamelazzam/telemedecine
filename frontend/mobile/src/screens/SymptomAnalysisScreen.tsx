import React from 'react';
import { View, Text, StyleSheet } from 'react-native';

export default function SymptomAnalysisScreen() {
  return (
    <View style={styles.container}>
      <Text style={styles.title}>Symptom Analysis</Text>
      <Text style={styles.note}>This screen will show symptom suggestions and analysis (placeholder).</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, padding: 16 },
  title: { fontSize: 22, marginBottom: 12 },
  note: { color: '#666' },
});
