import React, { useState } from 'react';
import { View, Text, TouchableOpacity, StyleSheet } from 'react-native';

export default function Tabs({ routes = [], renderScene = {} as Record<string, React.ComponentType<any>> }: any) {
  const [index, setIndex] = useState(0);
  const activeKey = routes[index]?.key;
  const Scene = renderScene[activeKey] || (() => null);
  return (
    <View style={{ flex: 1 }}>
      <View style={styles.header}>
        {routes.map((r: any, i: number) => (
          <TouchableOpacity key={r.key} onPress={() => setIndex(i)} style={[styles.tab, i === index && styles.tabActive]}>
            <Text style={i === index ? styles.tabTextActive : styles.tabText}>{r.title}</Text>
          </TouchableOpacity>
        ))}
      </View>
      <View style={{ flex: 1 }}>
        <Scene />
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  header: { flexDirection: 'row', borderBottomWidth: 1, borderBottomColor: '#eee' },
  tab: { paddingVertical: 12, paddingHorizontal: 16 },
  tabActive: { borderBottomWidth: 2, borderBottomColor: '#7c3aed' },
  tabText: { color: '#444' },
  tabTextActive: { color: '#7c3aed', fontWeight: '700' },
});
