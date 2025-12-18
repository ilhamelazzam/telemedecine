import React from 'react';
import { View, TextInput, StyleSheet } from 'react-native';

export default function InputOTP({ length = 4 }: { length?: number }) {
  return (
    <View style={styles.row}>
      {Array.from({ length }).map((_, i) => (
        <TextInput key={i} style={styles.box} maxLength={1} keyboardType="number-pad" />
      ))}
    </View>
  );
}

const styles = StyleSheet.create({ row: { flexDirection: 'row', gap: 8 }, box: { width: 44, height: 44, borderWidth: 1, borderColor: '#ddd', textAlign: 'center' as const } });
