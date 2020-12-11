import React, { useState } from 'react';
import { SafeAreaView, View, StyleSheet } from 'react-native';
import ContextMenu from 'react-native-context-menu-view';

const App = () => {
  const [color, setColor] = useState('blue');
  const [circle, setCircle] = useState(false)

  return (
    <SafeAreaView style={styles.container}>
      <ContextMenu title={'Customize'} actions={[
        {
          title: 'Change Color',
          systemIcon: 'paintbrush',
          inlineChildren: true,
          actions: [
            {
              title: 'Blue',
              systemIcon: color === 'blue' ? 'paintbrush.fill' : 'paintbrush',
            },
            {
              title: 'Red',
              systemIcon: color === 'red' ? 'paintbrush.fill' : 'paintbrush',
            },
          ]
        },
        {
          title: 'Transparent',
          systemIcon: 'trash',
          destructive: true,
        },
        {
          title: 'Toggle Circle',
          systemIcon: 'circlebadge'
        },
        {
          title: 'Disabled Item',
          disabled: true,
        },
      ]} onPress={(event) => {
        const {index, name} = event.nativeEvent;
        if (index < 3) {
          setColor(name.toLowerCase());
        } else {
          setCircle(!circle)
        }
      }} onCancel={() => {
        console.warn('CANCELLED')
      }} previewBackgroundColor="transparent">
        <View style={[styles.rectangle, {backgroundColor: color, borderRadius: circle ? 999 : 0}]} />
      </ContextMenu>
      <View style={{color: 'red', height: 100, width: 100}} />
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