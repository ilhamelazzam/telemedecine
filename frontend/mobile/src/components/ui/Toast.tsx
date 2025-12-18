import React from 'react';
import { View, Text, StyleSheet } from 'react-native';

export default function Toast({ message }: { message?: string }) {
  if (!message) return null;
  return (
    <View style={styles.container}>
      <Text style={styles.text}>{message}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: { position: 'absolute', bottom: 20, left: 20, right: 20, backgroundColor: '#333', padding: 12, borderRadius: 8 },
  text: { color: '#fff' },
});
