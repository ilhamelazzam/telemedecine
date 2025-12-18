import * as React from 'react';
import { View, FlatList, StyleSheet, Alert } from 'react-native';
import { Title, Card, Paragraph, Button, Dialog, Portal } from 'react-native-paper';
import { analyses, patients } from '../data/mockData';
import userService from '../services/userService';
import treatmentService, { Treatment } from '../services/treatmentService';

export default function DashboardScreen() {
  const [role, setRole] = React.useState<'patient' | 'doctor' | undefined>(undefined);
  const latestAnalyses = (analyses || []).slice(0, 4);
  const [treatments, setTreatments] = React.useState<any[]>([]);
  const [view, setView] = React.useState<'pending'|'validated'>('pending');
  const [confirmVisible, setConfirmVisible] = React.useState(false);
  const [selectedTreatment, setSelectedTreatment] = React.useState<Treatment | null>(null);

  React.useEffect(() => {
    let mounted = true;
    userService.getUser().then((u) => {
      if (mounted) setRole(u.role);
    });
    return () => { mounted = false; };
  }, []);

  React.useEffect(() => {
    if (role !== 'doctor') return;
    let mounted = true;
    treatmentService.getTreatments().then((list) => { if (mounted) setTreatments(list); });
    const unsub = treatmentService.subscribe(() => {
      treatmentService.getTreatments().then((list) => setTreatments(list));
    });
    return () => { mounted = false; unsub(); };
  }, [role]);

  if (role === 'doctor') {
    return (
      <View style={[styles.container, { backgroundColor: '#f9f5ff' }]}>
        <Title style={styles.title}>Doctor Dashboard</Title>

        <Card style={styles.card}>
          <Card.Title title="Treatments" subtitle={`${treatments.filter(t => !t.validated).length} awaiting review`} />
          <Card.Content>
            <Paragraph>Review and validate proposed treatments below.</Paragraph>
            <View style={{ flexDirection: 'row', marginTop: 8 }}>
              <Button mode={view === 'pending' ? 'contained' : 'outlined'} onPress={() => setView('pending')} style={{ marginRight: 8 }}>Pending</Button>
              <Button mode={view === 'validated' ? 'contained' : 'outlined'} onPress={() => setView('validated')}>Validated</Button>
            </View>
          </Card.Content>
        </Card>

        <Title style={[styles.title, { marginTop: 12 }]}>{view === 'pending' ? 'Pending' : 'Validated'}</Title>
        <FlatList
          data={view === 'pending' ? treatments.filter((t) => !t.validated) : treatments.filter((t) => t.validated)}
          keyExtractor={(t) => t.id}
          renderItem={({ item }) => (
            <Card style={styles.card}>
              <Card.Title title={item.patientName} subtitle={item.description} />
              <Card.Content>
                <Paragraph>Patient: {item.patientName}</Paragraph>
                {item.validated && (
                  <Paragraph style={{ marginTop: 8, color: '#4b5563' }}>Validated by {item.doctor ?? '—'} on {item.validatedAt ? new Date(item.validatedAt).toLocaleString() : '—'}</Paragraph>
                )}
              </Card.Content>
              {!item.validated && (
                <Card.Actions>
                  <Button mode="contained" onPress={() => { setSelectedTreatment(item); setConfirmVisible(true); }}>Validate</Button>
                </Card.Actions>
              )}
            </Card>
          )}
        />

        <Portal>
          <Dialog visible={confirmVisible} onDismiss={() => setConfirmVisible(false)}>
            <Dialog.Title>Validate treatment</Dialog.Title>
            <Dialog.Content>
              <Paragraph>Are you sure you want to validate this treatment?</Paragraph>
            </Dialog.Content>
            <Dialog.Actions>
              <Button onPress={() => setConfirmVisible(false)}>Cancel</Button>
              <Button onPress={async () => {
                if (!selectedTreatment) return setConfirmVisible(false);
                const u = await userService.getUser();
                const name = u.name ?? 'Dr. Demo';
                await treatmentService.validateTreatment(selectedTreatment.id, name);
                setConfirmVisible(false);
              }}>Validate</Button>
            </Dialog.Actions>
          </Dialog>
        </Portal>

        <Title style={[styles.title, { marginTop: 16 }]}>Recent Analyses</Title>
        <FlatList
          data={latestAnalyses}
          keyExtractor={(i) => i.id?.toString() ?? Math.random().toString()}
          renderItem={({ item }) => (
            <Card style={styles.card}>
              <Card.Title title={item.patient ?? 'Patient'} subtitle={item.date} />
              <Card.Content>
                <Paragraph>Result: {item.result ?? '—'}</Paragraph>
              </Card.Content>
            </Card>
          )}
        />
      </View>
    );
  }

  // default patient view
  return (
    <View style={[styles.container, { backgroundColor: '#f9f5ff' }]}>
      <Title style={styles.title}>Welcome</Title>

      <Card style={styles.card}>
        <Card.Title title="Your Summary" subtitle={`${(patients || []).length} patients in demo`} />
        <Card.Content>
          <Paragraph>Open your recent analyses or request a new check.</Paragraph>
          <Button mode="contained" style={{ marginTop: 8 }}>View Records</Button>
        </Card.Content>
      </Card>

      <Title style={[styles.title, { marginTop: 16 }]}>Recent Analyses</Title>
      <FlatList
        data={latestAnalyses}
        keyExtractor={(i) => i.id?.toString() ?? Math.random().toString()}
        renderItem={({ item }) => (
          <Card style={styles.card}>
            <Card.Title title={item.patient ?? 'Analysis'} subtitle={item.date} />
            <Card.Content>
              <Paragraph>Result: {item.result ?? 'No result'}</Paragraph>
            </Card.Content>
          </Card>
        )}
      />
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, padding: 12 },
  title: { marginBottom: 8 },
  card: { marginBottom: 10 },
});
