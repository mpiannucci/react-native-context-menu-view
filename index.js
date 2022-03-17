import React from "react";
import { requireNativeComponent, View } from "react-native";

const NativeContextMenu = requireNativeComponent("ContextMenu", null);

const ContextMenu = (props) => {
  return (
    <NativeContextMenu {...props}>
      <View>{props.children}</View>
      {props.preview}
    </NativeContextMenu>
  );
};

export default ContextMenu;
