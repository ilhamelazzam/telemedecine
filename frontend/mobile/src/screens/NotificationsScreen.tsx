import * as React from 'react';
import { View, FlatList, StyleSheet, Alert } from 'react-native';
import { Card, Title, List, IconButton } from 'react-native-paper';
import notificationService from '../services/notificationService';

export default function NotificationsScreen() {
  const [items, setItems] = React.useState<Array<any>>([]);

  const load = React.useCallback(async () => {
    const arr = await notificationService.getNotifications();
    setItems(arr);
  }, []);

  React.useEffect(() => {
    load();
    const unsub = notificationService.subscribe(() => load());
    return unsub;
  }, [load]);

  const handlePress = async (id: string) => {
    try {
      await notificationService.markAsRead(id);
    } catch (e) {
      Alert.alert('Error', 'Could not mark notification read');
    }
  };

  return (
    <View style={[styles.container, { backgroundColor: '#f9f5ff' }]}>
      <Title style={styles.title}>Notifications</Title>
      <FlatList
        data={items}
        keyExtractor={(n) => n.id?.toString() ?? Math.random().toString()}
        renderItem={({ item }) => (
          <Card style={[styles.card, item.read ? { opacity: 0.6 } : {}]}>
            <Card.Content>
              <List.Item
                title={item.text ?? 'Notification'}
                description={item.date}
                onPress={() => handlePress(item.id)}
                right={() => <IconButton icon={item.read ? 'check' : 'bell'} onPress={() => handlePress(item.id)} />}
              />
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
  card: { marginBottom: 8 },
});
