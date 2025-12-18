import React from 'react';
import { View } from 'react-native';

export default function Skeleton({ width = '100%', height = 12 }: { width?: number | string; height?: number }) {
  return <View style={{ width: width as any, height, backgroundColor: '#eee', borderRadius: 4 }} />;
}
