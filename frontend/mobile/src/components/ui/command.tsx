import React from 'react';
import { View } from 'react-native';

export default function Command({ children }: { children?: React.ReactNode }) {
  return <View>{children}</View>;
}
