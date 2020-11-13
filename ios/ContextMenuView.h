//
//  ContextMenu.h
//  reactnativeuimenu
//
//  Created by Matthew Iannucci on 10/6/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <React/RCTComponent.h>
#import "ContextMenuAction.h"

@interface ContextMenuView : UIView<UIContextMenuInteractionDelegate>

@property (nonatomic, copy) NSString* title;
@property (nonatomic, copy) RCTBubblingEventBlock onPress;
@property (nonatomic, copy) RCTBubblingEventBlock onCancel;
@property (nonatomic, copy) NSArray<ContextMenuAction*>* actions;

@property (nullable, nonatomic, copy) UIColor* previewBackgroundColor;

@end
