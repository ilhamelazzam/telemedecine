import React from 'react';
import { Modal, View, Text, StyleSheet, TouchableOpacity } from 'react-native';

type Props = {
  visible: boolean;
  title?: string;
  description?: string;
  confirmText?: string;
  cancelText?: string;
  onConfirm?: () => void;
  onCancel?: () => void;
};

export default function AlertDialog({
  visible,
  title,
  description,
  confirmText = 'OK',
  cancelText = 'Cancel',
  onConfirm,
  onCancel,
}: Props) {
  return (
    <Modal animationType="fade" transparent visible={visible} onRequestClose={onCancel}>
      <View style={styles.overlay}>
        <View style={styles.container}>
          {title ? <Text style={styles.title}>{title}</Text> : null}
          {description ? <Text style={styles.description}>{description}</Text> : null}
          <View style={styles.footer}>
            <TouchableOpacity style={[styles.button, styles.cancel]} onPress={onCancel}>
              <Text style={styles.cancelText}>{cancelText}</Text>
            </TouchableOpacity>
            <TouchableOpacity style={[styles.button, styles.confirm]} onPress={onConfirm}>
              <Text style={styles.confirmText}>{confirmText}</Text>
            </TouchableOpacity>
          </View>
        </View>
      </View>
    </Modal>
  );
}

const styles = StyleSheet.create({
  overlay: { flex: 1, backgroundColor: 'rgba(0,0,0,0.5)', justifyContent: 'center', alignItems: 'center' },
  container: { width: '90%', backgroundColor: '#fff', padding: 20, borderRadius: 8 },
  title: { fontSize: 18, fontWeight: '600', marginBottom: 8 },
  description: { color: '#444', marginBottom: 16 },
  footer: { flexDirection: 'row', justifyContent: 'flex-end' },
  button: { paddingVertical: 10, paddingHorizontal: 14, borderRadius: 6, marginLeft: 8 },
  cancel: { backgroundColor: '#f1f1f1' },
  confirm: { backgroundColor: '#007AFF' },
  cancelText: { color: '#111' },
  confirmText: { color: '#fff' },
});
