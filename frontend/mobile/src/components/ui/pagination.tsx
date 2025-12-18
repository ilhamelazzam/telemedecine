import React from 'react';
import { View, Button } from 'react-native';

export default function Pagination({ onPrev, onNext }: { onPrev?: () => void; onNext?: () => void }) {
  return (
    <View style={{ flexDirection: 'row', justifyContent: 'space-between' }}>
      <Button title="Prev" onPress={onPrev} />
      <Button title="Next" onPress={onNext} />
    </View>
  );
}
