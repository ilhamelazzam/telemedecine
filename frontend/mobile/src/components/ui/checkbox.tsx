import React from 'react';
import { View, Text } from 'react-native';
import { Checkbox as PaperCheckbox } from 'react-native-paper';

export default function Checkbox({ label, checked, onPress }: { label?: string; checked?: boolean; onPress?: () => void }) {
  return (
    <View style={{ flexDirection: 'row', alignItems: 'center' }}>
      <PaperCheckbox status={checked ? 'checked' : 'unchecked'} onPress={onPress} />
      {label ? <Text style={{ marginLeft: 8 }}>{label}</Text> : null}
    </View>
  );
}
