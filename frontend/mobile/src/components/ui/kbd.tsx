import React from 'react';
import { Text, StyleSheet } from 'react-native';

export default function Kbd({ children }: { children?: React.ReactNode }) {
  return <Text style={styles.kbd}>{children}</Text>;
}

const styles = StyleSheet.create({ kbd: { backgroundColor: '#eee', paddingHorizontal: 6, paddingVertical: 2, borderRadius: 4, fontFamily: 'monospace' } });
