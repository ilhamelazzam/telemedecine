import React from 'react';
import { View, Text, StyleSheet } from 'react-native';

export default function Alert({ title, children }: { title?: string; children?: React.ReactNode }) {
  return (
    <View style={styles.container}>
      {title ? <Text style={styles.title}>{title}</Text> : null}
      {children}
    </View>
  );
}

const styles = StyleSheet.create({ container: { padding: 8 }, title: { fontWeight: '700' } });
