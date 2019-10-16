//
//  ContextMenu.h
//  reactnativeuimenu
//
//  Created by Matthew Iannucci on 10/6/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <React/RCTComponent.h>
#import "RnContextMenuAction.h"

@interface RnContextMenuView : UIView<UIContextMenuInteractionDelegate>

@property (nonatomic, copy) NSString* title;
@property (nonatomic, copy) RCTBubblingEventBlock onPress;
@property (nonatomic, copy) NSArray<RnContextMenuAction*>* actions;

@end
