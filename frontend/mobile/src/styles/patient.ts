import { StyleSheet } from 'react-native';
import { colors } from './global';

export default StyleSheet.create({
  layout: { flex: 1, backgroundColor: colors.background },
  header: { padding: 16, backgroundColor: colors.primary, flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between' },
  headerTitle: { color: '#fff', fontSize: 18, fontWeight: '800' },
  sidebar: { width: 250, backgroundColor: '#fff', borderRightWidth: 1, borderRightColor: colors.primaryLight },
  main: { flex: 1, padding: 16 },
  card: { backgroundColor: '#fff', borderRadius: 12, padding: 16, elevation: 4 },
  sectionTitle: { fontSize: 20, fontWeight: '800', color: colors.primaryDark },
  btnPrimary: { backgroundColor: colors.primary, padding: 12, borderRadius: 10 },
  formInput: { backgroundColor: '#fafbfc', borderRadius: 10 },
  // Additional mappings from web CSS
  patientLayout: { flex: 1, backgroundColor: colors.background },
  headerLeft: { flexDirection: 'row', alignItems: 'center', gap: 12 },
  headerRight: { flexDirection: 'row', alignItems: 'center', gap: 12 },
  sidebarToggle: { display: 'none' as any },
  navList: { padding: 0 },
  navLink: { flexDirection: 'row', alignItems: 'center', gap: 12, paddingVertical: 12, paddingHorizontal: 24 },
  navLinkActive: { backgroundColor: 'rgba(124,58,237,0.12)', borderLeftWidth: 4, borderLeftColor: colors.primaryDark, paddingLeft: 20 },
  patientMain: { flex: 1, padding: 32, alignSelf: 'stretch', maxWidth: 1200 },
  cardContainer: { backgroundColor: '#fff', borderRadius: 20, padding: 24, elevation: 6, borderWidth: 1, borderColor: 'rgba(124,58,237,0.2)' },
  cardHeader: { flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center', marginBottom: 20 },
  severityBadge: { paddingHorizontal: 12, paddingVertical: 6, borderRadius: 20 },
  analysisItem: { flexDirection: 'row', justifyContent: 'space-between', paddingVertical: 12, borderBottomWidth: 1, borderBottomColor: '#e2e8f0' },
  formRow: { flexDirection: 'row', gap: 16 },
  formFieldset: { borderWidth: 1, borderColor: '#e2e8f0', borderRadius: 12, padding: 20, backgroundColor: '#fafbfc' },
  categoriesGrid: { flexDirection: 'row', flexWrap: 'wrap', gap: 12 },
  categoryBtn: { padding: 12, borderWidth: 1, borderColor: '#e2e8f0', borderRadius: 12, backgroundColor: '#fff' },
});
