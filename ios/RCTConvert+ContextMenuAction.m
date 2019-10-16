//
//  RCTConvert+ContextMenuAction.m
//  reactnativeuimenu
//
//  Created by Matthew Iannucci on 10/7/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "RCTConvert+ContextMenuAction.h"

@implementation RCTConvert(ContextMenuAction)

+ (RnContextMenuAction*) RnContextMenuAction:(id)json {
  json = [self NSDictionary:json];
    RnContextMenuAction* action = [[RnContextMenuAction alloc] init];
  action.title = [self NSString:json[@"title"]];
  action.systemIcon = [self NSString:json[@"systemIcon"]];
  return action;
}

+(NSArray<RnContextMenuAction*>*) RnContextMenuActionArray:(id)json {
  json = [self NSArray:json];
  NSMutableArray<RnContextMenuAction*>* actions = [[NSMutableArray alloc] init];
  
  for (NSDictionary* dict in json) {
    [actions addObject:[self RnContextMenuAction:dict]];
  }
  
  return [NSArray arrayWithArray:actions];
}

@end
