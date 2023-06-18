import React from "react";
import { requireNativeComponent, View, Platform, StyleSheet } from "react-native";

const NativeContextMenu = requireNativeComponent("ContextMenu", null);

const ContextMenu = (props) => {
  return (
    <NativeContextMenu {...props}>
      {props.children}
      {props.preview != null && Platform.OS === 'ios' ? (
        <View style={styles.preview} nativeID="ContextMenuPreview">{props.preview}</View>
      ) : null}
    </NativeContextMenu>
  );
};

const styles = StyleSheet.create({
  preview: {
    position: 'absolute',
    overflow: 'visible',
    backgroundColor: 'transparent'
  }
});

export default ContextMenu;
