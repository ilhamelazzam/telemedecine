import React from 'react';
import { Drawer as PaperDrawer } from 'react-native-paper';

export default function Drawer({ children }: { children?: React.ReactNode }) {
  return <PaperDrawer.Section>{children as any}</PaperDrawer.Section>;
}
