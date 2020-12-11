# react-native-context-menu-view

Use native context menu functionality from React Native. On iOS 13+ this uses `UIMenu` functionality, and on Android it uses a `PopUpMenu`.

On iOS 12 and below, nothing happens. You may wish to do a `Platform.OS === 'ios' && parseInt(Platform.Version, 10) <= 12` check, and add your own `onLongPress` handler.

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
      <View style={styles.yourOwnStyles} />
    </ContextMenu>
  );
};
```

See `example/` for basic usage.

## Props

###### `title`

Optional. The title above the popup menu.

###### `actions`

Array of `{ title: string, systemIcon?: string, destructive?: boolean, disabled?: boolean, inlineChildren?: boolean, children?: Array<ContextMenuAction> }`.

System icon refers to an icon name within [SF Symbols](https://developer.apple.com/design/human-interface-guidelines/sf-symbols/overview/).

Destructive items are rendered in red on iOS, and unchanged on Android.

Nested menus are supported on iOS only and result in nested UIMenu which can be optionally displayed inline. 

###### `onPress`

Optional. When the popup is opened and the user picks an option. Called with `{ nativeEvent: { index, name } }`. When a nested action is selected the top level parent index is used for the callback. 

###### `onCancel`

Optional. When the popop is opened and the user cancels.

###### `previewBackgroundColor`

Optional. The background color of the preview. This is displayed underneath your view. Set this to transparent (or another color) if the default causes issues.
