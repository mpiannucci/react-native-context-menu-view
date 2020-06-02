import React, { useState } from 'react';
import { SafeAreaView, View, StyleSheet } from 'react-native';
import ContextMenu from 'react-native-context-menu-view';

const App = () => {
  const [color, setColor] = useState('blue');

  return (
    <SafeAreaView style={styles.container}>
      <ContextMenu title={'Set Color'} actions={[
        {
          title: 'blue',
          systemIcon: color === 'blue' ? 'paintbrush.fill' : 'paintbrush',
        },
        {
          title: 'red',
          systemIcon: color === 'red' ? 'paintbrush.fill' : 'paintbrush',
        },
        {
          title: 'transparent',
          systemIcon: 'trash',
          destructive: true,
        },
        {
          title: 'disabled item',
          disabled: true,
        },
      ]} onPress={(event) => {
        setColor(event.nativeEvent.name);
      }} onCancel={() => { console.warn('CANCELLED') }} >
        <View style={[styles.rectangle, {backgroundColor: color }]} />
      </ContextMenu>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center'
  },
  rectangle: {
    width: 200, 
    height: 200,
  }
});

export default App;