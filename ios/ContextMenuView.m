//
//  ContextMenu.m
//  reactnativeuimenu
//
//  Created by Matthew Iannucci on 10/6/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "ContextMenuView.h"
#import <React/UIView+React.h>

@implementation ContextMenuView {
  BOOL cancelled;
}

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
    
    [self.actions enumerateObjectsUsingBlock:^(ContextMenuAction* thisAction, NSUInteger idx, BOOL *stop) {
      UIAction* actionMenuItem = [UIAction actionWithTitle:thisAction.title.capitalizedString image:[UIImage systemImageNamed:thisAction.systemIcon] identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
        if (self.onPress != nil) {
          self->cancelled = false;
          self.onPress(@{
            @"index": @(idx),
            @"name": thisAction.title,
          });
        }
      }];

      [actions addObject:actionMenuItem];
    }];
                              
    return [UIMenu menuWithTitle:self.title children:actions];
  }];
}

- (void)contextMenuInteraction:(UIContextMenuInteraction *)interaction willDisplayMenuForConfiguration:(UIContextMenuConfiguration *)configuration animator:(id<UIContextMenuInteractionAnimating>)animator  API_AVAILABLE(ios(13.0)){
  cancelled = true;
}

- (void)contextMenuInteraction:(UIContextMenuInteraction *)interaction
willEndForConfiguration:(UIContextMenuConfiguration *)configuration
                      animator:(id<UIContextMenuInteractionAnimating>)animator  API_AVAILABLE(ios(13.0)) API_AVAILABLE(ios(13.0)){
  
  if (cancelled && self.onCancel) {
    self.onCancel(@{});
  }
  
}

@end
