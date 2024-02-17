# react-native-context-menu-view

Use native context menu functionality from React Native. On iOS 13+ this uses [`UIMenu`](https://developer.apple.com/documentation/uikit/uimenu) functionality, and on Android it uses a [`ContextMenu`](https://developer.android.com/reference/android/view/ContextMenu).

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

### `title`

Optional. The title above the popup menu.

### `actions`

Array of `{ title: string, subtitle?: string, systemIcon?: string, icon?: string, iconColor?: string, destructive?: boolean, selected?: boolean, disabled?: boolean, disabled?: boolean, inlineChildren?: boolean, actions?: Array<ContextMenuAction> }`.

- `title` is the title of the action

- `subtitle` is the subtitle of the action (iOS 15+ only)

- `systemIcon` refers to an icon name within [SF Symbols](https://developer.apple.com/design/human-interface-guidelines/sf-symbols/overview/) (iOS only)

- `icon` refers to an SVG asset name that is provided in Assets.xcassets or to a Drawable on Android; when both `systemIcon` and `icon` are provided, `icon` will take a higher priority and it will override `systemIcon`

- `iconColor` will change the color of the icon provided to the `icon` prop and has no effect on `systemIcon` (default: black)

- `destructive` items are rendered in red (iOS only, default: false)

- `selected` items have a checkmark next to them (iOS only, default: false)

- `disabled` marks whether the action is disabled or not (default: false)

- `actions` will provide a one level deep nested menu; when child actions are supplied, the child's callback will contain its name but the same index as the topmost parent menu/action index

- `inlineChildren` marks whether its children (if any) should be rendered inline instead of in their own child menu (iOS only, default: false)

### `onPress`

Optional. When the popup is opened and the user picks an option. Called with `{ nativeEvent: { index, indexPath, name } }`. When a nested action is selected the top level parent index is used for the callback.

To get the full path to the item, `indexPath` is an array of indices to reach the item. For a top-level item, it'll be an array with a single index. For an item one deep, it'll be an array with two indexes.

### `onPreviewPress`

Optional, iOS only. When the context menu preview is tapped.

### `onCancel`

Optional. When the popup is opened and the user cancels.

### `previewBackgroundColor`

Optional. The background color of the preview. This is displayed underneath your view. Set this to transparent (or another color) if the default causes issues.

### `dropdownMenuMode`

Optional. When set to `true`, the context menu is triggered with a single tap instead of a long press, and a preview is not show and no blur occurs. Uses the iOS 14 Menu API on iOS and a simple tap listener on android.

### `disabled`

Optional. Disable menu interaction.
