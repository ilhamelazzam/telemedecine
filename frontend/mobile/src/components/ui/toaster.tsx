import React from 'react';
import { Snackbar } from 'react-native-paper';

export default function Toaster({ message, visible = !!message, onDismiss }: { message?: string; visible?: boolean; onDismiss?: (() => void) | undefined }) {
  return (
    <Snackbar visible={visible} onDismiss={onDismiss ?? (() => {})} duration={3000}>
      {message}
    </Snackbar>
  );
}
