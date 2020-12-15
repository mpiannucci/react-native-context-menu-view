import { Component } from 'react';
import { NativeSyntheticEvent, ViewProps, ViewStyle } from 'react-native';

export interface ContextMenuAction {
	/**
	 * The title of the action
	 */
	title: string;
	/**
	 * The icon to use on ios. This is the name of the SFSymbols icon to use. On Android nothing will happen if you set this option. 
	 */
	systemIcon?: string;
	/**
	 * Destructive items are rendered in red on iOS, and unchanged on Android. (default: false)
	 */
	destructive?: boolean;
	/**
	* Whether the action is disabled or not (default: false)
	*/
	disabled?: boolean;
	/**
	 * Whether its children (if any) should be rendered inline instead of in their own child menu (default: false, iOS only)
	 */
	inlineChildren?: boolean;
	/**
	 * Child actions. When child actions are supplied, the childs callback will contain its name but the same index as the topmost parent menu/action index. (iOS Only)
	 */
	actions?: Array<ContextMenuAction>;
}

export interface ContextMenuOnPressNativeEvent {
	index: number;
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
	 * Handle when the menu is cancelled and closed
	 */
	onCancel?: () => void;
	/**
	 * The background color of the preview. This is displayed underneath your view. Set this to transparent (or another color) if the default causes issues.
	 */
	previewBackgroundColor?: ViewStyle["backgroundColor"];
}

export default class ContextMenu extends Component<ContextMenuProps> { }
