#import "ContextMenu.h"
#import "ContextMenuView.h"

@implementation ContextMenu

RCT_EXPORT_MODULE()

- (UIView *) view {
  return [[ContextMenuView alloc] init];
}

RCT_EXPORT_VIEW_PROPERTY(title, NSString)
RCT_EXPORT_VIEW_PROPERTY(onPress, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onCancel, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(actions, NSArray<ContextMenuAction>)
RCT_CUSTOM_VIEW_PROPERTY(previewBackgroundColor, UIColor, ContextMenuView) {
  view.previewBackgroundColor = json != nil ? [RCTConvert UIColor:json] : nil;
}

@end
