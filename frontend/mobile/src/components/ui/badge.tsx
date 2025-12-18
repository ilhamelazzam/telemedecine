import React from 'react';
import { Chip } from 'react-native-paper';

export default function Badge({ children }: { children?: React.ReactNode }) {
  return <Chip>{children as any}</Chip>;
}
