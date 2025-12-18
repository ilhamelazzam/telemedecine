import React from 'react';
import { View } from 'react-native';

// 'sonner' is a web toast lib in the original; here we create a minimal placeholder
export default function Sonner({ children }: { children?: React.ReactNode }) {
  return <View>{children}</View>;
}
