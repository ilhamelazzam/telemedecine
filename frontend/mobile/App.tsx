import { StatusBar } from 'expo-status-bar';
import React from 'react';
import AppNavigation from './src/navigation';
import { Provider as PaperProvider, DefaultTheme } from 'react-native-paper';
import { colors } from './src/styles/global';

const theme = {
  ...DefaultTheme,
  colors: {
    ...DefaultTheme.colors,
    primary: colors.primary,
    onPrimary: '#ffffff',
    secondary: colors.accent,
    background: colors.background,
    surface: '#ffffff',
    text: colors.text,
  },
};

export default function App() {
  return (
    <PaperProvider theme={theme}>
      <AppNavigation />
    </PaperProvider>
  );
}
