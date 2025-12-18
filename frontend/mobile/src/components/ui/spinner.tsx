import React from 'react';
import { ActivityIndicator } from 'react-native';

export default function Spinner({ size = 'small' }: { size?: 'small' | 'large' }) {
  return <ActivityIndicator size={size} />;
}
