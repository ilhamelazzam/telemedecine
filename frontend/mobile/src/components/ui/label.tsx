import React from 'react';
import { Text } from 'react-native';

export default function Label({ children }: { children?: React.ReactNode }) {
  return <Text style={{ fontWeight: '600', marginBottom: 4 }}>{children}</Text>;
}
