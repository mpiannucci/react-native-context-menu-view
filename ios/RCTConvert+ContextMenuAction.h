//
//  RCTConvert+ContextMenuAction.h
//  reactnativeuimenu
//
//  Created by Matthew Iannucci on 10/7/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import <React/RCTConvert.h>

#import "RnContextMenuAction.h"

@interface RCTConvert (RnContextMenuAction)

+(RnContextMenuAction*) RnContextMenuAction:(id)json;
+(NSArray<RnContextMenuAction*>*) RnContextMenuActionArray:(id)json;

@end
