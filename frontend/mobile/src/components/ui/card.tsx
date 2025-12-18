import React from 'react';
import { Card as PaperCard } from 'react-native-paper';

export default function Card({ children }: { children?: React.ReactNode }) {
  return <PaperCard style={{ borderRadius: 8 }}>{children}</PaperCard>;
}
