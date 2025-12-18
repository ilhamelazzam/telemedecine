import React from 'react';
import { ProgressBar } from 'react-native-paper';

export default function Progress({ value = 0 }: { value?: number }) {
  return <ProgressBar progress={value} />;
}
