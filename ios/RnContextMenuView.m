//
//  ContextMenu.m
//  reactnativeuimenu
//
//  Created by Matthew Iannucci on 10/6/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "RnContextMenuView.h"
#import <React/UIView+React.h>

@implementation RnContextMenuView

- (void)insertReactSubview:(UIView *)subview atIndex:(NSInteger)atIndex
{
  [super insertReactSubview:subview atIndex:atIndex];
  if (@available(iOS 13.0, *)) {
    UIContextMenuInteraction* contextInteraction = [[UIContextMenuInteraction alloc] initWithDelegate:self];
    
    [subview addInteraction:contextInteraction];
  }
}

- (void)removeReactSubview:(UIView *)subview
{
    [super removeReactSubview:subview];
}

- (void)didUpdateReactSubviews
{
  [super didUpdateReactSubviews];
}

- (void)layoutSubviews
{
  [super layoutSubviews];
}

- (nullable UIContextMenuConfiguration *)contextMenuInteraction:(nonnull UIContextMenuInteraction *)interaction configurationForMenuAtLocation:(CGPoint)location  API_AVAILABLE(ios(13.0)){
  
  return [UIContextMenuConfiguration configurationWithIdentifier:nil previewProvider:nil actionProvider:^UIMenu * _Nullable(NSArray<UIMenuElement *> * _Nonnull suggestedActions) {
    NSMutableArray* actions = [[NSMutableArray alloc] init];
    
    for (RnContextMenuAction* thisAction in self.actions) {
      UIAction* actionMenuItem = [UIAction actionWithTitle:thisAction.title.capitalizedString image:[UIImage systemImageNamed:thisAction.systemIcon] identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
        if (self.onPress != nil) {
          self.onPress(@{@"name": thisAction.title});
        }
      }];
      
      [actions addObject:actionMenuItem];
    }
                              
    return [UIMenu menuWithTitle:self.title children:actions];
  }];
}

@end
