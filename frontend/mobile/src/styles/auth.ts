import { StyleSheet } from 'react-native';
import { colors } from './global';

export default StyleSheet.create({
  container: { flex: 1, backgroundColor: colors.background, padding: 16, justifyContent: 'center' },
  card: { width: '100%', maxWidth: 460, padding: 28, borderRadius: 20, backgroundColor: '#fff', elevation: 6 },
  header: { alignItems: 'center', marginBottom: 18 },
  icon: { width: 76, height: 76, borderRadius: 24, alignItems: 'center', justifyContent: 'center', marginBottom: 12 },
  title: { fontSize: 28, fontWeight: '800', textAlign: 'center' },
  subtitle: { fontSize: 14, color: colors.muted, textAlign: 'center', marginBottom: 12 },
  form: { gap: 12 },
  input: { backgroundColor: '#f6f1ff' },
  btnPrimary: { marginTop: 8 },
  footer: { marginTop: 16, alignItems: 'center' },
});
