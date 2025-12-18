import { useEffect, useState } from 'react';

export default function useMobile() {
  const [isMobile] = useState(true);
  useEffect(() => {}, []);
  return { isMobile };
}
