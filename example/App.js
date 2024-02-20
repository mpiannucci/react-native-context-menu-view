import React, { useState } from 'react';
import { SafeAreaView, View, StyleSheet, Platform, TouchableOpacity, Alert, processColor } from 'react-native';
import ContextMenu from 'react-native-context-menu-view';

const Icons = Platform.select({
  ios: {
    changeColor: 'paintbrush',
    transparent: 'trash',
    toggleCircle: 'circlebadge'
  },
  android: {
    changeColor: 'baseline_format_paint',
    transparent: 'baseline_delete',
    toggleCircle: 'outline_circle',
  }
})

const App = () => {
  const [color, setColor] = useState('blue');
  const [previousColor, setPreviousColor] = useState('blue');
  const [circle, setCircle] = useState(false)

  return (
    <SafeAreaView style={styles.container}>
      <ContextMenu title={'Customize'} actions={[
        {
          title: 'Change Color',
          systemIcon: Icons.changeColor,
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
          systemIcon: Icons.transparent,
          destructive: true,
        },
        {
          title: 'Custom Icon and Color',
          customIcon: Platform.OS === 'ios' ? 'bluetooth' : '',
          customIconColor: Platform.OS === 'ios' ? processColor('green') : '',
        },
        {
          title: 'Toggle Circle',
          systemIcon: Icons.toggleCircle,
        },
        {
          title: 'Disabled Item',
          disabled: true,
        },
      ]} onPress={(event) => {
        const { index, indexPath, name } = event.nativeEvent;
        if (indexPath?.at(0) == 0) {
          // The first item is nested in a submenu
          setColor(name.toLowerCase());
        } else if (index == 1) {
          if (color !== 'transparent') {
            setPreviousColor(color);
            setColor('transparent');
          } else {
            setColor(previousColor);
          }
        } else if (index == 2) {
          setCircle(!circle)
        }
      }} onCancel={() => {
        console.warn('CANCELLED')
      }} previewBackgroundColor="transparent">
        <View style={[styles.rectangle, { backgroundColor: color, borderRadius: circle ? 999 : 0 }]} />
      </ContextMenu>

      <View style={styles.spacer} />

      <ContextMenu
        title={'Dropdown Menu'}
        actions={[
          {
            title: 'Test Item',
          }
        ]}
        dropdownMenuMode={true}
      >
        <View style={[styles.rectangle, { backgroundColor: 'purple' }]} />
      </ContextMenu>

      <View style={styles.spacer} />

      <ContextMenu
        title={'Custom Preview'}
        actions={[
          {
            title: 'Test Item',
          },
        ]}
        previewBackgroundColor="transparent"
        preview={
          <TouchableOpacity onPress={() => console.log('TAPPP')}>
            <View style={[styles.rectangle, { backgroundColor: 'green' }]} />
          </TouchableOpacity>
        }
        onPreviewPress={() => Alert.alert('Preview Tapped')}>
        <View style={[styles.rectangle, { backgroundColor: 'red' }]} />
      </ContextMenu>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'flex-start',
    alignItems: 'center'
  },
  rectangle: {
    width: 200,
    height: 200,
  },
  spacer: {
    height: 16,
  }
});

export default App;
