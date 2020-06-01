# react-native-context-menu-view

Use native context menu functionality from React Native. On iOS 13+ this uses `UIMenu` functionality, and on Android it uses a `PopUpMenu`.

On iOS 12 and below, nothing happens. You may wish to do a `Platform.OS === 'ios' && parseInt(Platform.Version, 10) < 12` check, and add your own `onLongPress` handler.

<img src="./assets/context-menu-ios.gif" width="300">

## Getting started

`$ npm install react-native-context-menu-view --save`

### Mostly automatic installation

```bash
cd ios/
pod install
```

## Usage

```javascript
import ContextMenu from "react-native-context-menu-view";

const Example = () => {
  return (
    <ContextMenu
      actions={[{ title: "Title 1" }, { title: "Title 2" }]}
      onPress={(e) => {
        console.warn(
          `Pressed ${e.nativeEvent.name} at index ${e.nativeEvent.index}`
        );
      }}
    >
      <View style={styles.yourOwnStyles}>
    </ContextMenu>
  );
};
```

See `example/` for basic usage.

## Props

###### `title`

Optional. The title above the popup menu.

###### `actions`

Array of `{ title?: string, systemIcon?: string }`. System icon refers to an icon name within [SF Symbols](https://developer.apple.com/design/human-interface-guidelines/sf-symbols/overview/).

###### `onPress`

Optional. When the popup is opened and the user picks an option. Called with `{ nativeEvent: { index, name } }`.

###### `onCancel`

Optional. When the popop is opened and the user cancels.
