import React from 'react';
import { View, StyleSheet } from 'react-native';
import { NativeStackScreenProps } from '@react-navigation/native-stack';
import { RootStackParamList } from '../navigation';
import { Card, Title, Paragraph } from 'react-native-paper';

type Props = NativeStackScreenProps<RootStackParamList, 'AnalysisDetail'>;

export default function AnalysisDetailScreen({ route }: Props) {
  const { id } = route.params as any;
  return (
    <View style={[styles.container, { backgroundColor: '#f9f5ff' }]}>
      <Card>
        <Card.Title title={`Analysis ${id}`} />
        <Card.Content>
          <Paragraph>Details for analysis {id} (placeholder)</Paragraph>
        </Card.Content>
      </Card>
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, padding: 12 },
});
