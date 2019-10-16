#import "RnContextMenu.h"
#import "RnContextMenuView.h"

@implementation RnContextMenu

RCT_EXPORT_MODULE()

- (UIView *) view {
  return [[RnContextMenuView alloc] init];
}

RCT_EXPORT_VIEW_PROPERTY(title, NSString)
RCT_EXPORT_VIEW_PROPERTY(onPress, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(actions, NSArray<ContextMenuAction>)

@end
