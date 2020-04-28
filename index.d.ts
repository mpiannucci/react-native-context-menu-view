import { Component } from 'react';
import { NativeSyntheticEvent } from 'react-native';

export interface ContextMenuAction {
	/**
	 * The title of the action
	 */
	title?: string;
	/**
	 * The icon to use on ios. This is the name of the SFSymbols icon to use. On Android nothing will happen if you set this option. 
	 */
	systemIcon?: string;
}

export interface ContextMenu extends Component {
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
	onPress?: (e: NativeSyntheticEvent<{name: string}>) => void;
	/**
	 * Handle when the menu is cancelled and closed
	 */
	onCancel?: () => void;
}
