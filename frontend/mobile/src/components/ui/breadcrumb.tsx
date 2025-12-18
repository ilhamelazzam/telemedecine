import React from 'react';
import { View, Text } from 'react-native';

export default function Breadcrumb({ children }: { children?: React.ReactNode }) {
  return (
    <View style={{ flexDirection: 'row' }}>
      {children}
    </View>
  );
}
