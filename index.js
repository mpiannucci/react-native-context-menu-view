import React from "react";
import { requireNativeComponent, View, Platform, StyleSheet, processColor } from "react-native";

const NativeContextMenu = requireNativeComponent("ContextMenu", null);

const ContextMenu = (props) => {
  const defaultProps = {
    borderRadius: -1,
    borderTopLeftRadius: -1,
    borderTopRightRadius: -1,
    borderBottomRightRadius: -1,
    borderBottomLeftRadius: -1
  };

  const iconColor = props?.iconColor
    ? Platform.OS === 'ios'
      ? processColor(props.iconColor)
      : props.iconColor
    : undefined;

  return (
    <NativeContextMenu {...defaultProps} {...props} iconColor={iconColor}>
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
