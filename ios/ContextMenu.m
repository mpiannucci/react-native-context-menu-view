#import "ContextMenu.h"
#import "ContextMenuView.h"

@implementation ContextMenu

RCT_EXPORT_MODULE()

- (UIView *) view {
    ContextMenuView *contextMenuView = [[ContextMenuView alloc] init];
    return contextMenuView;
}

RCT_EXPORT_VIEW_PROPERTY(title, NSString)
RCT_EXPORT_VIEW_PROPERTY(onPress, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onPreviewPress, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onCancel, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(actions, NSArray<ContextMenuAction>)
RCT_EXPORT_VIEW_PROPERTY(disabled, BOOL)
RCT_CUSTOM_VIEW_PROPERTY(previewBackgroundColor, UIColor, ContextMenuView) {
  view.previewBackgroundColor = json != nil ? [RCTConvert UIColor:json] : nil;
}
RCT_EXPORT_VIEW_PROPERTY(borderRadius, CGFloat)
RCT_EXPORT_VIEW_PROPERTY(borderTopLeftRadius, CGFloat)
RCT_EXPORT_VIEW_PROPERTY(borderTopRightRadius, CGFloat)
RCT_EXPORT_VIEW_PROPERTY(borderBottomRightRadius, CGFloat)
RCT_EXPORT_VIEW_PROPERTY(borderBottomLeftRadius, CGFloat)
RCT_EXPORT_VIEW_PROPERTY(disableShadow, BOOL)
RCT_CUSTOM_VIEW_PROPERTY(dropdownMenuMode, BOOL, ContextMenuView) {
    if (@available(iOS 14.0, *)) {
        view.showsMenuAsPrimaryAction = json != nil ? [RCTConvert BOOL:json] : view.showsMenuAsPrimaryAction;
    } else {
        // This is not available on other versions... sorry!
    }
}

@end
