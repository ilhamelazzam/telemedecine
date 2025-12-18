import React from 'react';
import { View, FlatList, StyleSheet } from 'react-native';
import { Card, Title, Paragraph } from 'react-native-paper';

const mockHistory = [
  { id: '1', title: 'Analysis #1', date: '2025-11-01' },
  { id: '2', title: 'Analysis #2', date: '2025-11-05' },
];

export default function HistoryScreen() {
  return (
    <View style={[styles.container, { backgroundColor: '#f9f5ff' }]}>
      <Title style={styles.title}>History</Title>
      <FlatList
        data={mockHistory}
        keyExtractor={(i) => i.id}
        renderItem={({ item }) => (
          <Card style={styles.card}>
            <Card.Title title={item.title} subtitle={item.date} />
            <Card.Content>
              <Paragraph>Result summary placeholder</Paragraph>
            </Card.Content>
          </Card>
        )}
      />
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, padding: 12 },
  title: { fontSize: 22, marginBottom: 12 },
  card: { marginBottom: 10 },
});
