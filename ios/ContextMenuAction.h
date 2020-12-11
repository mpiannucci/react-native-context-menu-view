//
//  ContextMenuAction.h
//  reactnativeuimenu
//
//  Created by Matthew Iannucci on 10/6/19.
//  Copyright © 2019 Matthew Iannucci. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContextMenuAction : NSObject

@property (nonnull, nonatomic, copy) NSString* title;
@property (nullable, nonatomic, copy) NSString* systemIcon;
@property (nonatomic, assign) BOOL destructive;
@property (nonatomic, assign) BOOL disabled;
@property (nonatomic, assign) BOOL inlineChildren;
@property (nullable, nonatomic, copy) NSArray<ContextMenuAction*>* actions;

@end
