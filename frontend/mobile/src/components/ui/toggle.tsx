import React from 'react';
import { TouchableOpacity, Text } from 'react-native';

export default function Toggle({ value, onToggle }: { value?: boolean; onToggle?: () => void }) {
  return (
    <TouchableOpacity onPress={onToggle} style={{ padding: 8, backgroundColor: value ? '#007AFF' : '#eee', borderRadius: 6 }}>
      <Text style={{ color: value ? '#fff' : '#000' }}>{value ? 'On' : 'Off'}</Text>
    </TouchableOpacity>
  );
}
