import React from 'react';
import { TextInput, StyleSheet } from 'react-native';

export default function Textarea(props: any) {
  return <TextInput multiline style={styles.input} {...props} />;
}

const styles = StyleSheet.create({ input: { borderWidth: 1, borderColor: '#ddd', padding: 10, borderRadius: 6, minHeight: 100 } });
