import React, { Component } from "react";
import {
  NativeSyntheticEvent,
  ViewProps,
  ViewStyle,
  ProcessedColorValue,
} from "react-native";

export interface ContextMenuAction {
  /**
   * The title of the action
   */
  title: string;
  /**
   * The subtitle of the action. iOS 15+.
   */
  subtitle?: string;
  /**
   * The system icon to use. This is the name of the SFSymbols icon (iOS only).
   */
  systemIcon?: string;
  /**
   * The icon to use. This is the name of the SVG that is provided in Assets.xcassets (iOS) or the name of the Drawable (Android). It overrides the systemIcon prop.
   */
  icon?: string;
  /**
   * Color of the icon (default: black). The color only applies to the icon provided to the icon prop, as the color of the systemIcon is always black and cannot be changed with this prop.
   */
  iconColor?: string;
  /**
   * Destructive items are rendered in red on iOS, and unchanged on Android. (default: false)
   */
  destructive?: boolean;
  /**
   * Selected items have a checkmark next to them on iOS, and unchanged on Android. (default: false)
   */
  selected?: boolean;
  /**
   * Whether the action is disabled or not (default: false)
   */
  disabled?: boolean;
  /**
   * Whether its children (if any) should be rendered inline instead of in their own child menu (default: false, iOS only)
   */
  inlineChildren?: boolean;
  /**
   * Child actions. When child actions are supplied, the child's callback will contain its name but the same index as the topmost parent menu/action index
   */
  actions?: Array<ContextMenuAction>;
}

export interface ContextMenuOnPressNativeEvent {
  index: number;
  indexPath: number[];
  name: string;
}

export interface ContextMenuProps extends ViewProps {
  /**
   * The title of the menu
   */
  title?: string;
  /**
   * The actions to show the user when the menu is activated
   */
  actions?: Array<ContextMenuAction>;
  /**
   * Handle when an action is triggered and the menu is closed. The name of the selected action will be passed in the event.
   */
  onPress?: (e: NativeSyntheticEvent<ContextMenuOnPressNativeEvent>) => void;
  /**
   * Handle when the preview is tapped. iOS only.
   */
  onPreviewPress?: () => void;
  /**
   * Handle when the menu is cancelled and closed
   */
  onCancel?: () => void;
  /**
   * The background color of the preview. This is displayed underneath your view. Set this to transparent (or another color) if the default causes issues.
   */
  previewBackgroundColor?: ViewStyle["backgroundColor"];
  /**
   * Custom preview component.
   */
  preview?: React.ReactNode;
  /**
   * When enabled, uses iOS 14 menu mode, and shows the context menu on a single tap with no zoomed preview.
   */
  dropdownMenuMode?: boolean;
  /**
   * Disable menu interaction
   */
  disabled?: boolean;
  /**
   * Children prop as per upgrade docs: https://reactjs.org/blog/2022/03/08/react-18-upgrade-guide.html#updates-to-typescript-definitions
   */
  children?: React.ReactNode;
}

export default class ContextMenu extends Component<ContextMenuProps> {}
