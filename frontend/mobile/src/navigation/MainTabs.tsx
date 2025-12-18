import * as React from 'react';
import { View, StyleSheet } from 'react-native';
import { BottomNavigation, Badge, useTheme } from 'react-native-paper';
import { MaterialCommunityIcons } from '@expo/vector-icons';
import DashboardScreen from '../screens/DashboardScreen';
import PatientScreen from '../screens/PatientScreen';
import NewAnalysisScreen from '../screens/NewAnalysisScreen';
import HistoryScreen from '../screens/HistoryScreen';
import NotificationsScreen from '../screens/NotificationsScreen';
import { notifications } from '../data/mockData';
import notificationService from '../services/notificationService';

export default function MainTabs() {
  const theme = useTheme();
  const [index, setIndex] = React.useState(0);
  const [unread, setUnread] = React.useState<number>(0);

  React.useEffect(() => {
    let mounted = true;
    async function load() {
      const c = await notificationService.getUnreadCount();
      if (mounted) setUnread(c);
    }
    load();
    const unsub = notificationService.subscribe(() => {
      notificationService.getUnreadCount().then((c) => setUnread(c)).catch(() => {});
    });
    return () => {
      mounted = false;
      unsub();
    };
  }, []);

  const renderIconWithBadge = (name: string, badgeCount = 0) => ({ size, color }: any) => (
    <View style={{ width: 36, height: 36, alignItems: 'center', justifyContent: 'center' }}>
      <MaterialCommunityIcons name={name as any} size={size} color={color} />
      {badgeCount > 0 && <Badge style={[styles.badge, { backgroundColor: theme.colors.primary }]} size={16}>{badgeCount}</Badge>}
    </View>
  );

  const routes = [
    { key: 'home', title: 'Home', icon: 'home' },
    { key: 'patients', title: 'Patients', icon: 'account-multiple' },
    { key: 'new', title: 'New', icon: 'plus-box' },
    { key: 'history', title: 'History', icon: 'history' },
    // notifications uses a custom icon renderer so we can show a badge
    { key: 'notifications', title: 'Alerts', icon: renderIconWithBadge('bell', unread) },
  ];

  const renderScene = BottomNavigation.SceneMap({
    home: DashboardScreen,
    patients: PatientScreen,
    new: NewAnalysisScreen,
    history: HistoryScreen,
    notifications: NotificationsScreen,
  });

  return (
    <BottomNavigation
      navigationState={{ index, routes }}
      onIndexChange={setIndex}
      renderScene={renderScene}
      barStyle={{ backgroundColor: theme.colors.surface }}
    />
  );
}

const styles = StyleSheet.create({
  badge: {
    position: 'absolute',
    top: -4,
    right: -10,
    elevation: 2,
  },
});
