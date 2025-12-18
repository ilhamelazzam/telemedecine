import React, { useState } from 'react';
import { View, Alert, StyleSheet } from 'react-native';
import { TextInput as PaperInput, Button as PaperButton, Title } from 'react-native-paper';
import { NativeStackScreenProps } from '@react-navigation/native-stack';
import { RootStackParamList } from '../navigation';
import { register } from '../services/authApi';

type Props = NativeStackScreenProps<RootStackParamList, 'Register'>;

export default function RegisterScreen({ navigation }: Props) {
  const [name, setName] = useState('');
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [loading, setLoading] = useState(false);

  const handleRegister = async () => {
    try {
      setLoading(true);
      await register({ name, email, password });
      Alert.alert('Registered', 'You can now sign in');
      navigation.navigate('Login');
    } catch (err: any) {
      Alert.alert('Register failed', err?.response?.data?.message || err.message);
    } finally {
      setLoading(false);
    }
  };

  return (
    <View style={[styles.container, { backgroundColor: '#f9f5ff' }]}>
      <Title style={styles.title}>Create account</Title>
      <PaperInput label="Name" mode="outlined" value={name} onChangeText={setName} style={styles.input} />
      <PaperInput label="Email" mode="outlined" autoCapitalize="none" value={email} onChangeText={setEmail} style={styles.input} />
      <PaperInput label="Password" mode="outlined" secureTextEntry value={password} onChangeText={setPassword} style={styles.input} />
      <PaperButton mode="contained" onPress={handleRegister} loading={loading} disabled={loading} style={{ marginTop: 8 }}>
        {loading ? 'Creating…' : 'Create account'}
      </PaperButton>
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, padding: 16, justifyContent: 'center' },
  title: { fontSize: 22, marginBottom: 12, textAlign: 'center' },
  input: { marginBottom: 12 },
});
