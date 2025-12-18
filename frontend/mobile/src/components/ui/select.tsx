import React from 'react';
import { View, Text, TouchableOpacity } from 'react-native';

export default function Select({ options = [], onSelect }: { options?: string[]; onSelect?: (v: string) => void }) {
  return (
    <View>
      {options.map((o) => (
        <TouchableOpacity key={o} onPress={() => onSelect && onSelect(o)}>
          <Text style={{ padding: 8 }}>{o}</Text>
        </TouchableOpacity>
      ))}
    </View>
  );
}
