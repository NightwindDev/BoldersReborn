#import <Preferences/PSSliderTableCell.h>
#import <Preferences/PSSpecifier.h>
#import <substrate.h>
#import "rootless.h"

@interface UIView (Private)
-(UIViewController *)_viewControllerForAncestor;
@end

@interface BoldersRebornSliderCell : PSSliderTableCell
- (NSNumber *)controlValue;
@end