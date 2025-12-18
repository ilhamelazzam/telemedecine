import React from 'react';
import { ScrollView } from 'react-native';

export default function ScrollArea({ children }: { children?: React.ReactNode }) {
  return <ScrollView>{children}</ScrollView>;
}
