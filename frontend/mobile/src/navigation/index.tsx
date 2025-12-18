import React from 'react';
import { NavigationContainer } from '@react-navigation/native';
import { createNativeStackNavigator } from '@react-navigation/native-stack';
import LoginScreen from '../screens/LoginScreen';
import RegisterScreen from '../screens/RegisterScreen';
import DashboardScreen from '../screens/DashboardScreen';
import HistoryScreen from '../screens/HistoryScreen';
import PatientScreen from '../screens/PatientScreen';
import AnalysisDetailScreen from '../screens/AnalysisDetailScreen';
import NewAnalysisScreen from '../screens/NewAnalysisScreen';
import SymptomAnalysisScreen from '../screens/SymptomAnalysisScreen';
import NotificationsScreen from '../screens/NotificationsScreen';
import MainTabs from './MainTabs';

export type RootStackParamList = {
  Login: undefined;
  Register: undefined;
  Dashboard: undefined;
  Patients: undefined;
  History: undefined;
  AnalysisDetail: { id?: string } | undefined;
  NewAnalysis: undefined;
  SymptomAnalysis: undefined;
  Notifications: undefined;
};

const Stack = createNativeStackNavigator<RootStackParamList>();

export default function AppNavigation() {
  return (
    <NavigationContainer>
      <Stack.Navigator initialRouteName="Login">
        <Stack.Screen name="Login" component={LoginScreen} />
        <Stack.Screen name="Register" component={RegisterScreen} />
        {/* Dashboard route now hosts the bottom tabs */}
        <Stack.Screen name="Dashboard" component={MainTabs} options={{ headerShown: false }} />
        <Stack.Screen name="Patients" component={PatientScreen} />
        <Stack.Screen name="History" component={HistoryScreen} />
        <Stack.Screen name="AnalysisDetail" component={AnalysisDetailScreen} />
        <Stack.Screen name="NewAnalysis" component={NewAnalysisScreen} />
        <Stack.Screen name="SymptomAnalysis" component={SymptomAnalysisScreen} />
        <Stack.Screen name="Notifications" component={NotificationsScreen} />
      </Stack.Navigator>
    </NavigationContainer>
  );
}
