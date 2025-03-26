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

  const colorConvertedActions = props?.actions?.map((action) => ({
    ...action,
    iconColor: Platform.OS === 'ios' && action.iconColor ? processColor(action.iconColor) : action.iconColor,
    titleColor: Platform.OS === 'ios' && action.titleColor ? processColor(action.titleColor) : action.titleColor,
  }));

  return (
    <NativeContextMenu {...defaultProps} {...props} actions={colorConvertedActions}>
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
