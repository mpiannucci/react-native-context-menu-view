//
//  ContextMenu.m
//  reactnativeuimenu
//
//  Created by Matthew Iannucci on 10/6/19.
//  Copyright © 2019 Matthew Iannucci. All rights reserved.
//

#import "ContextMenuView.h"
#import <React/UIView+React.h>

@interface ContextMenuView ()

- (UIMenuElement*) createMenuElementForAction:(ContextMenuAction *)action atIndexPath:(NSUInteger) idx API_AVAILABLE(ios(13.0));

@end

@implementation ContextMenuView {
  BOOL _cancelled;
  UIView *_customView;
}

- (id) init {
    self = [super init];

    if (@available(iOS 14.0, *)) {
        self.contextMenuInteractionEnabled = true;
    } else {
        // Fallback on earlier versions
    }

    return self;
}

- (void)insertReactSubview:(UIView *)subview atIndex:(NSInteger)atIndex
{
  if ([subview.nativeID isEqualToString:@"ContextMenuPreview"]) {
    _customView = subview;
    return;
  }

  [super insertReactSubview:subview atIndex:atIndex];

  if (@available(iOS 13.0, *)) {
    UIContextMenuInteraction* contextInteraction =
      [[UIContextMenuInteraction alloc] initWithDelegate:self];

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

- (nullable UIContextMenuConfiguration *)contextMenuInteraction:(nonnull UIContextMenuInteraction *)interaction configurationForMenuAtLocation:(CGPoint)location API_AVAILABLE(ios(13.0)) {
  if (_disabled) {
    return nil;
  }

  return [UIContextMenuConfiguration
          configurationWithIdentifier:nil
          previewProvider:_customView == nil ? nil : ^(){
            UIViewController* viewController = [[UIViewController alloc] init];
            viewController.preferredContentSize = self->_customView.frame.size;
            viewController.view = self->_customView;
            return viewController;
          }
          actionProvider:^UIMenu * _Nullable(NSArray<UIMenuElement *> * _Nonnull suggestedActions) {
            NSMutableArray* actions = [[NSMutableArray alloc] init];

            [self.actions enumerateObjectsUsingBlock:^(ContextMenuAction* thisAction, NSUInteger idx, BOOL *stop) {
              UIMenuElement *menuElement = [self createMenuElementForAction:thisAction atIndexPath:[NSArray arrayWithObject:@(idx)]];
              [actions addObject:menuElement];
            }];

            return [UIMenu menuWithTitle:self.title children:actions];
          }];
}

- (void)contextMenuInteraction:(UIContextMenuInteraction *)interaction willDisplayMenuForConfiguration:(UIContextMenuConfiguration *)configuration animator:(id<UIContextMenuInteractionAnimating>)animator API_AVAILABLE(ios(13.0)) {
  _cancelled = true;
}

- (void)contextMenuInteraction:(UIContextMenuInteraction *)interaction willPerformPreviewActionForMenuWithConfiguration:(nonnull UIContextMenuConfiguration *)configuration animator:(nonnull id<UIContextMenuInteractionCommitAnimating>)animator API_AVAILABLE(ios(13.0)) {
    if (self.onPreviewPress) {
        self.onPreviewPress(@{});
    }
}

- (void)contextMenuInteraction:(UIContextMenuInteraction *)interaction willEndForConfiguration:(UIContextMenuConfiguration *)configuration animator:(id<UIContextMenuInteractionAnimating>)animator API_AVAILABLE(ios(13.0)) {
  if (_cancelled && self.onCancel) {
    self.onCancel(@{});
  }
}

- (UITargetedPreview *)contextMenuInteraction:(UIContextMenuInteraction *)interaction previewForHighlightingMenuWithConfiguration:(UIContextMenuConfiguration *)configuration API_AVAILABLE(ios(13.0)) {
    UIPreviewTarget* previewTarget = [[UIPreviewTarget alloc] initWithContainer:self center:self.reactSubviews.firstObject.center];
    UIPreviewParameters* previewParams = [[UIPreviewParameters alloc] init];

    if (_previewBackgroundColor != nil) {
      previewParams.backgroundColor = _previewBackgroundColor;
    }

    return [[UITargetedPreview alloc] initWithView:self.reactSubviews.firstObject
                                        parameters:previewParams
                                            target:previewTarget];
}

- (UIMenuElement*) createMenuElementForAction:(ContextMenuAction *)action atIndexPath:(NSArray<NSNumber *> *)indexPath {
    UIMenuElement* menuElement = nil;
    UIImage *iconImage = nil;

    if (action.icon != nil) {
        UIColor *iconColor = [UIColor blackColor];

        if (action.iconColor != nil) {
            iconColor = action.iconColor;
        }
        // Use custom icon from Assets.xcassets
        iconImage = [[UIImage imageNamed:action.icon] imageWithTintColor:iconColor];
    } else {
        // Use system icon from SF Symbols
        iconImage = [UIImage systemImageNamed:action.systemIcon];
    }
    
    if (action.actions != nil && action.actions.count > 0) {
      NSMutableArray<UIMenuElement*> *children = [[NSMutableArray alloc] init];
      [action.actions enumerateObjectsUsingBlock:^(ContextMenuAction * _Nonnull childAction, NSUInteger childIdx, BOOL * _Nonnull stop) {
        id nextIndexPath = [indexPath arrayByAddingObject:@(childIdx)];
        UIMenuElement *childElement = [self createMenuElementForAction:childAction atIndexPath:nextIndexPath];
        if (childElement != nil) {
          [children addObject:childElement];
        }
      }];

      UIMenuOptions actionMenuOptions =
        (action.inlineChildren ? UIMenuOptionsDisplayInline : 0) |
        (action.destructive ? UIMenuOptionsDestructive : 0);
      UIMenu *actionMenu = [UIMenu menuWithTitle:action.title
                                           image:iconImage
                                      identifier:nil
                                         options:actionMenuOptions
                                        children:children];

      if (@available(iOS 15.0, *)) {
        actionMenu.subtitle = action.subtitle;
      }

      menuElement = actionMenu;
    } else {
      UIAction* actionMenuItem =
        [UIAction actionWithTitle:action.title image:iconImage identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
          if (self.onPress != nil) {
            self->_cancelled = false;
            self.onPress(@{
              @"index": [indexPath lastObject],
              @"indexPath": indexPath,
              @"name": action.title,
            });
          }
        }];

      if (@available(iOS 15.0, *)) {
        actionMenuItem.subtitle = action.subtitle;
      }

      actionMenuItem.attributes =
        (action.destructive ? UIMenuElementAttributesDestructive : 0) |
        (action.disabled ? UIMenuElementAttributesDisabled : 0);

      actionMenuItem.state = 
      	action.selected ? UIMenuElementStateOn : UIMenuElementStateOff;

      menuElement = actionMenuItem;
    }

    return menuElement;
}

@end
