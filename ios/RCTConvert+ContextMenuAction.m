//
//  RCTConvert+ContextMenuAction.m
//  reactnativeuimenu
//
//  Created by Matthew Iannucci on 10/7/19.
//  Copyright © 2019 Matthew Iannucci. All rights reserved.
//

#import "RCTConvert+ContextMenuAction.h"

@implementation RCTConvert(ContextMenuAction)

+ (ContextMenuAction*) ContextMenuAction:(id)json {
    json = [self NSDictionary:json];
    ContextMenuAction* action = [[ContextMenuAction alloc] init];
    action.title = [self NSString:json[@"title"]];
    action.systemIcon = [self NSString:json[@"systemIcon"]];
    action.destructive = [self BOOL:json[@"destructive"]];
    action.disabled = [self BOOL:json[@"disabled"]];
    action.inlineChildren = [self BOOL:json[@"inlineChildren"]];
    
    NSArray *rawChildActions = [self NSArray:json[@"actions"]];
    NSMutableArray<ContextMenuAction*> *childActions = [[NSMutableArray alloc] init];
    for (NSDictionary* dict in rawChildActions) {
        ContextMenuAction *childAction = [self ContextMenuAction:dict];
        [childActions addObject: childAction];
    }
    action.actions = childActions;
    return action;
}

+(NSArray<ContextMenuAction*>*) ContextMenuActionArray:(id)json {
  json = [self NSArray:json];
  NSMutableArray<ContextMenuAction*>* actions = [[NSMutableArray alloc] init];
  
  for (NSDictionary* dict in json) {
    [actions addObject:[self ContextMenuAction:dict]];
  }
  
  return [NSArray arrayWithArray:actions];
}

@end
