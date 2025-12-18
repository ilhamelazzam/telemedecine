import React from 'react';
import { StyleProp, ViewStyle } from 'react-native';
import { Button as PaperButton } from 'react-native-paper';

type Props = {
  title: string;
  onPress?: () => void;
  style?: StyleProp<ViewStyle>;
  disabled?: boolean;
  mode?: 'contained' | 'outlined' | 'text';
};

export default function Button({ title, onPress, style, disabled, mode = 'contained' }: Props) {
  return (
    <PaperButton mode={mode} onPress={onPress} disabled={disabled} style={style}>
      {title}
    </PaperButton>
  );
}
