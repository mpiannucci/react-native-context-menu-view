import React from "react";
import { requireNativeComponent, View } from "react-native";

const NativeContextMenu = requireNativeComponent("ContextMenu", null);

const ContextMenu = (props) => {
  return (
    <NativeContextMenu {...props}>
      {props.children}
      {props.preview != null ? (
        <View nativeID="ContextMenuPreview">{props.preview}</View>
      ) : null}
    </NativeContextMenu>
  );
};

export default ContextMenu;
