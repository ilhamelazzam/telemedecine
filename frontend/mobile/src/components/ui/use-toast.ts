import { useState, useCallback } from 'react';

export default function useToast() {
  const [message, setMessage] = useState<string | undefined>(undefined);
  const show = useCallback((msg: string) => setMessage(msg), []);
  const hide = useCallback(() => setMessage(undefined), []);
  return { message, show, hide };
}
