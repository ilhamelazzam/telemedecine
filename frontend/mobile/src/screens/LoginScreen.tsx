import React, { useState } from 'react';
import { View, Text, StyleSheet, Alert } from 'react-native';
import { TextInput as PaperInput, Button as PaperButton, Title, useTheme } from 'react-native-paper';
import { colors } from '../styles/global';
import userService from '../services/userService';
import { RadioButton } from 'react-native-paper';
import { NativeStackScreenProps } from '@react-navigation/native-stack';
import { RootStackParamList } from '../navigation';
import { login } from '../services/authApi';

type Props = NativeStackScreenProps<RootStackParamList, 'Login'>;

export default function LoginScreen({ navigation }: Props) {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [loading, setLoading] = useState(false);
  const [role, setRole] = useState<'patient'|'doctor'>('patient');
  const theme = useTheme();

  const handleLogin = async () => {
    try {
      setLoading(true);
      await login(email, password);
      // persist chosen role and name for UI
      await userService.saveUser({ role, name: email });
      navigation.reset({ index: 0, routes: [{ name: 'Dashboard' }] });
    } catch (err: any) {
      Alert.alert('Login failed', err?.response?.data?.message || err.message);
    } finally {
      setLoading(false);
    }
  };

  const handleDemoLogin = async () => {
    const demoEmail = 'demo@demo.com';
    const demoPass = 'demo123';
    try {
      setLoading(true);
      // call login directly with demo credentials (no need to wait for state update)
      await login(demoEmail, demoPass);
      await userService.saveUser({ role, name: 'Demo User' });
      navigation.reset({ index: 0, routes: [{ name: 'Dashboard' }] });
    } catch (err: any) {
      Alert.alert('Demo login failed', err?.response?.data?.message || err.message);
    } finally {
      setLoading(false);
    }
  };

  return (
    <View style={[styles.container, { backgroundColor: colors.background }] }>
      <Title style={styles.title}>Sign in</Title>
      <PaperInput
        label="Email"
        mode="outlined"
        keyboardType="email-address"
        autoCapitalize="none"
        value={email}
        onChangeText={setEmail}
        style={styles.input}
      />
      <PaperInput
        label="Password"
        mode="outlined"
        secureTextEntry
        value={password}
        onChangeText={setPassword}
        style={styles.input}
      />

      <RadioButton.Group onValueChange={(v) => setRole(v as any)} value={role}>
        <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'center', marginTop: 8 }}>
          <RadioButton value="patient" />
          <Text>Patient</Text>
          <RadioButton value="doctor" />
          <Text>Doctor</Text>
        </View>
      </RadioButton.Group>

      <PaperButton mode="contained" onPress={handleLogin} loading={loading} disabled={loading} style={[styles.primaryButton, { marginTop: 8 }]}
        labelStyle={{ color: '#fff' }}
      >
        {loading ? 'Signing in…' : 'Sign in'}
      </PaperButton>

      <PaperButton mode="outlined" onPress={handleDemoLogin} style={{ marginTop: 8 }}>
        Use demo credentials (auto sign-in)
      </PaperButton>

      <View style={styles.row}>
        <Text>Don't have an account?</Text>
        <PaperButton onPress={() => navigation.navigate('Register')}>Register</PaperButton>
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, padding: 16, justifyContent: 'center' },
  title: { fontSize: 24, marginBottom: 16, textAlign: 'center', color: colors.primaryDark },
  input: { marginBottom: 12 },
  row: { marginTop: 12, flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center' },
  primaryButton: { backgroundColor: colors.primary },
});
