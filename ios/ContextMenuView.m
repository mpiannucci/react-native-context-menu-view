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

- (UIPreviewParameters *)getPreviewParams {
    UIPreviewParameters* previewParams = [[UIPreviewParameters alloc] init];
    
    if (_previewBackgroundColor != nil) {
        previewParams.backgroundColor = _previewBackgroundColor;
    }
    
    if (self.borderRadius > -1 ||
        self.borderTopLeftRadius > -1 ||
        self.borderTopRightRadius > -1 ||
        self.borderBottomRightRadius > -1 ||
        self.borderBottomLeftRadius > -1) {
        
        CGFloat radius = self.borderRadius > -1 ? self.borderRadius : 0;
        CGFloat topLeftRadius = self.borderTopLeftRadius > -1 ? self.borderTopLeftRadius : radius;
        CGFloat topRightRadius = self.borderTopRightRadius > -1 ? self.borderTopRightRadius : radius;
        CGFloat bottomRightRadius = self.borderBottomRightRadius > -1 ? self.borderBottomRightRadius : radius;
        CGFloat bottomLeftRadius = self.borderBottomLeftRadius > -1 ? self.borderBottomLeftRadius : radius;
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        CGRect bounds = self.bounds;
        
        [path moveToPoint: CGPointMake(CGRectGetMinX(bounds) + topLeftRadius, CGRectGetMinY(bounds))];

        [path addLineToPoint: CGPointMake(CGRectGetMaxX(bounds) - topRightRadius, CGRectGetMinY(bounds))];
        [path addQuadCurveToPoint: CGPointMake(CGRectGetMaxX(bounds), CGRectGetMinY(bounds) + topRightRadius)
                    controlPoint: CGPointMake(CGRectGetMaxX(bounds), CGRectGetMinY(bounds))];

        [path addLineToPoint: CGPointMake(CGRectGetMaxX(bounds), CGRectGetMaxY(bounds) - bottomRightRadius)];
        [path addQuadCurveToPoint: CGPointMake(CGRectGetMaxX(bounds) - bottomRightRadius, CGRectGetMaxY(bounds))
                    controlPoint: CGPointMake(CGRectGetMaxX(bounds), CGRectGetMaxY(bounds))];

        [path addLineToPoint: CGPointMake(CGRectGetMinX(bounds) + bottomLeftRadius, CGRectGetMaxY(bounds))];
        [path addQuadCurveToPoint: CGPointMake(CGRectGetMinX(bounds), CGRectGetMaxY(bounds) - bottomLeftRadius)
                    controlPoint: CGPointMake(CGRectGetMinX(bounds), CGRectGetMaxY(bounds))];

        [path addLineToPoint: CGPointMake(CGRectGetMinX(bounds), CGRectGetMinY(bounds) + topLeftRadius)];
        [path addQuadCurveToPoint: CGPointMake(CGRectGetMinX(bounds) + topLeftRadius, CGRectGetMinY(bounds))
                    controlPoint: CGPointMake(CGRectGetMinX(bounds), CGRectGetMinY(bounds))];
        
        [path closePath];
        
        previewParams.visiblePath = path;
    }
    
    
    if (self.disableShadow) {
        previewParams.shadowPath = [UIBezierPath bezierPath];
    }
    
    return previewParams;
}

- (UITargetedPreview *)contextMenuInteraction:(UIContextMenuInteraction *)interaction previewForHighlightingMenuWithConfiguration:(UIContextMenuConfiguration *)configuration API_AVAILABLE(ios(13.0)) {
    UIPreviewTarget* previewTarget = [[UIPreviewTarget alloc] initWithContainer:self center:self.reactSubviews.firstObject.center];
    
    
    return [[UITargetedPreview alloc] initWithView:self.reactSubviews.firstObject
                                        parameters:[self getPreviewParams]
                                            target:previewTarget];
}

- (UITargetedPreview *)contextMenuInteraction:(UIContextMenuInteraction *)interaction previewForDismissingMenuWithConfiguration:(UIContextMenuConfiguration *)configuration API_AVAILABLE(ios(13.0)) {
    UIView *hostView = self.reactSubviews.firstObject;
    
    if (!hostView.window) {
        // The view is no longer available; it was unmounted.
        return nil;
    }
    
    UIPreviewTarget* previewTarget = [[UIPreviewTarget alloc] initWithContainer:self center:hostView.center];
    
    return [[UITargetedPreview alloc] initWithView:hostView
                                        parameters:[self getPreviewParams]
                                            target:previewTarget];
}

- (UIMenuElement*) createMenuElementForAction:(ContextMenuAction *)action atIndexPath:(NSArray<NSNumber *> *)indexPath {
    UIMenuElement* menuElement = nil;
    UIImage *iconImage = nil;

    if (action.icon != nil) {
        UIColor *iconColor;

        if (action.iconColor != nil) {
            iconColor = action.iconColor;
        } else {
            // Default color depends on dark mode
            if (@available(iOS 13.0, *)) {
                UIUserInterfaceStyle currentStyle = [UITraitCollection currentTraitCollection].userInterfaceStyle;
                iconColor = (currentStyle == UIUserInterfaceStyleDark) ? [UIColor whiteColor] : [UIColor blackColor];
            }
            // Fallback for iOS < 13
            else {
                iconColor = [UIColor blackColor]; 
            }
        }
        // Use custom icon from Assets.xcassets
        iconImage = [[UIImage imageNamed:action.icon] imageWithTintColor:iconColor];
    } else {
        // Use system icon from SF Symbols
        iconImage = [UIImage systemImageNamed:action.systemIcon];
    }

    UIColor *titleColor = nil;
    if (action.titleColor != nil) {
        titleColor = action.titleColor;
    } else {
        // Default title color depends on dark mode
        if (@available(iOS 13.0, *)) {
            UIUserInterfaceStyle currentStyle = [UITraitCollection currentTraitCollection].userInterfaceStyle;
            titleColor = (currentStyle == UIUserInterfaceStyleDark) ? [UIColor whiteColor] : [UIColor blackColor];
        } else {
            titleColor = [UIColor blackColor];
        }
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

      // Apply titleColor using attributedTitle
      if (titleColor != nil) {
          NSDictionary *attributes = @{NSForegroundColorAttributeName: titleColor};
          NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:action.title attributes:attributes];
          [actionMenuItem setValue:attributedTitle forKey:@"attributedTitle"];
      }

      menuElement = actionMenuItem;
    }

    return menuElement;
}

@end
