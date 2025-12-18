import React from 'react';
import { RadioButton } from 'react-native-paper';

export default function RadioGroup({ options = [], value, onChange }: { options?: string[]; value?: string; onChange?: (v: string) => void }) {
  return (
    <RadioButton.Group onValueChange={(v) => onChange && onChange(v)} value={value ?? ''}>
      {options.map((opt) => (
        <RadioButton.Item key={opt} label={opt} value={opt} />
      ))}
    </RadioButton.Group>
  );
}
