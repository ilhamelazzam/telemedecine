import * as React from 'react';
import { View, FlatList, StyleSheet } from 'react-native';
import { Card, Title, Paragraph, Avatar } from 'react-native-paper';
import { patients } from '../data/mockData';
import userService from '../services/userService';

export default function PatientScreen() {
  const [role, setRole] = React.useState<'patient' | 'doctor' | undefined>(undefined);
  React.useEffect(() => {
    let mounted = true;
    userService.getUser().then((u) => {
      if (mounted) setRole(u.role);
    });
    return () => { mounted = false; };
  }, []);

  const patientsList = patients || [];

  if (role === 'patient') {
    const me = patientsList[0] || { name: 'Demo Patient' };
    return (
      <View style={[styles.container, { backgroundColor: '#f9f5ff' }]}>
        <Title style={styles.title}>Hello, {me.name}</Title>
        <Card style={styles.card}>
          <Card.Title title="Your latest analysis" subtitle={me.lastAnalysis ?? '—'} />
          <Card.Content>
            <Paragraph>Tap to view details</Paragraph>
          </Card.Content>
        </Card>
      </View>
    );
  }

  return (
    <View style={[styles.container, { backgroundColor: '#f9f5ff' }]}>
      <Title style={styles.title}>Patients</Title>
      <FlatList
        data={patientsList}
        keyExtractor={(p) => p.id?.toString() ?? Math.random().toString()}
        renderItem={({ item }) => (
          <Card style={styles.card}>
            <Card.Title
              title={item.name}
              subtitle={item.age ? `${item.age} yrs` : undefined}
              left={(props) => <Avatar.Text {...props} size={40} label={(item.name || 'U').slice(0,2)} />}
            />
            <Card.Content>
              <Paragraph>Last analysis: {item.lastAnalysis ?? '—'}</Paragraph>
            </Card.Content>
          </Card>
        )}
      />
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, padding: 12 },
  card: { marginBottom: 10 },
  title: { marginBottom: 8 },
});
