import React from 'react';
import { View, StyleSheet } from 'react-native';
import { Avatar, Title, Card, Paragraph } from 'react-native-paper';

export default function ProfileScreen() {
  return (
    <View style={[styles.container, { backgroundColor: '#f9f5ff' }]}>
      <Card style={styles.card}>
        <Card.Title title="Dr. Demo" subtitle="Physician" left={(props) => <Avatar.Text {...props} size={48} label="DD" />} />
        <Card.Content>
          <Paragraph>Email: demo@demo.com</Paragraph>
          <Paragraph>Phone: +123 456 789</Paragraph>
        </Card.Content>
      </Card>
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, padding: 12 },
  card: { marginTop: 24 },
});
