//
//  RCTConvert+ContextMenuAction.h
//  reactnativeuimenu
//
//  Created by Matthew Iannucci on 10/7/19.
//  Copyright © 2019 Matthew Iannucci. All rights reserved.
//

#import <React/RCTConvert.h>

#import "ContextMenuAction.h"

@interface RCTConvert (ContextMenuAction)

+(ContextMenuAction*) ContextMenuAction:(id)json;
+(NSArray<ContextMenuAction*>*) ContextMenuActionArray:(id)json;

@end
