import React from "react";
import { requireNativeComponent, View, Platform } from "react-native";

const NativeContextMenu = requireNativeComponent("ContextMenu", null);

const ContextMenu = (props) => {
  return (
      <NativeContextMenu textColor={props.androidTextColor} menuColor={props.androidMenuColor} {...props}>
        {props.children}
        {props.preview != null && Platform.OS === 'ios' ? (
            <View nativeID="ContextMenuPreview">{props.preview}</View>
        ) : null}
      </NativeContextMenu>
  );
};

export default ContextMenu;
