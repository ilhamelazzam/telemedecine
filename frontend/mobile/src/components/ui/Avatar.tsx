import React from 'react';
import { Avatar as PaperAvatar } from 'react-native-paper';

type Props = { uri?: string; size?: number; name?: string };

export default function Avatar({ uri, size = 48, name }: Props) {
  if (uri) return <PaperAvatar.Image size={size} source={{ uri }} />;
  return <PaperAvatar.Text size={size} label={name ? name[0].toUpperCase() : '?'} />;
}
