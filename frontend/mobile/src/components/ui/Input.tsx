import React from 'react';
import { TextInput as PaperInput } from 'react-native-paper';

export default function Input(props: any) {
  return <PaperInput mode="outlined" {...props} />;
}
