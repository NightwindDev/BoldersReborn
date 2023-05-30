@import UIKit;
#import "rootless.h"

@interface UIView ()
- (UIViewController *)_viewControllerForAncestor;
@end

@interface SBFolderBackgroundView : UIView
@end

@interface SBHFolderIconVisualConfiguration : NSObject
@property (nonatomic, assign) CGSize gridCellSpacing;
@end

@interface SBIconListGridLayoutConfiguration : NSObject
@property (nonatomic, assign) BOOL isOldFolder;
@property (nonatomic, assign) BOOL check;
@property (nonatomic, strong) SBHFolderIconVisualConfiguration *folderIconVisualConfiguration;

- (BOOL)checkIfFolder;
- (void)setNumberOfPortraitColumns:(NSUInteger)arg1;
- (NSUInteger)numberOfPortraitColumns;
- (void)setNumberOfPortraitRows:(NSUInteger)arg1;
- (NSUInteger)numberOfPortraitRows;
@end

@interface _UITextLayoutCanvasView : UIView
@end

@interface _UITextFieldClearButton : UIButton
@end

@interface SBFolderTitleTextField : UITextField
@property (nonatomic, strong) _UITextLayoutCanvasView *_textCanvasView;
@property (nonatomic, strong) UIView *_backgroundView;
@property (nonatomic, strong) _UITextFieldClearButton *_clearButton;
@property (nonatomic, strong) UILabel *amtOfApps;
- (BOOL)showingEditUI;
@end

@interface SBFolderControllerBackgroundView : UIView
@end

@interface SBFolder : NSObject
@property (nonatomic, strong, readonly) NSArray *icons;
@property (nonatomic, assign) NSUInteger iconCount;
@property (nonatomic, strong) NSString *displayName;
@end

@interface SBFloatyFolderView : UIView
@property (nonatomic, strong) SBFolder *folder;
@property (nonatomic, strong) void (^outsideTapHandler)(void);
- (void)_handleOutsideTap:(id)arg1;
- (id)_viewControllerForAncestor;
@end

@interface SBFloatyFolderScrollView : UIView
@end

@interface SBIconListGridLayout : NSObject
@property (nonatomic, strong) SBIconListGridLayoutConfiguration *layoutConfiguration;
@end

@interface SBIconListFlowLayout : SBIconListGridLayout
@end

@interface SBIconGridImage : UIImage
@property (nonatomic, strong) SBIconListGridLayout *listLayout;
@property (nonatomic, assign) NSUInteger numberOfColumns;
@property (nonatomic, assign) NSUInteger numberOfRows;
- (id)iconImageAtIndex:(NSUInteger)index;
@end

@interface _SBIconGridWrapperView : UIImageView
- (void)adjustTransform;
@end

typedef struct SBHIconGridSize {
    short width;
    short height;
} SBHIconGridSize;

@interface SBIconListModel : NSObject
@property (nonatomic, strong) NSString *location;
@property (nonatomic, assign) NSUInteger maxNumberOfIcons;
@property (nonatomic, assign) NSUInteger numberOfIcons;
@property (nonatomic, strong) NSArray *icons;
@property (nonatomic, strong) SBFolder *folder;

- (SBIconListModel *)initWithFolder:(SBFolder *)folder maxIconCount:(NSUInteger)maxCount;
- (SBHIconGridSize)gridSizeForCurrentOrientation;
@end

@interface SBFolderController : UIView
@property (nonatomic, readonly, strong) UIView *containerView;
@end

@interface SBFolderIconImageCache : NSObject
@property (nonatomic, strong) SBIconListGridLayout *listLayout;
@end

@interface SBIconView : UIView
@property (nonatomic, assign, readwrite, getter=isIconContentScalingEnabled) BOOL iconContentScalingEnabled;
- (NSString *)applicationBundleIdentifierForShortcuts;
- (id)_viewControllerForAncestor;
- (BOOL)isFolderIcon;
- (void)_updateIconContentScale;
- (NSString *)location;
- (void)setIconContentScale:(CGFloat)scale;
@end

@interface SBHIconManager : NSObject
+ (SBHIconManager *)sharedInstance;
- (void)_closeFolderController:(id)arg0 animated:(BOOL)arg1 withCompletion:(id)arg2;
@end

@interface SBIconListPageControl : UIView
@end

@interface SBIconListFlowExtendedLayout : NSObject
@property (nonatomic, strong) SBIconListGridLayoutConfiguration *layoutConfiguration;
- (id)initWithLayoutConfiguration:(SBIconListGridLayoutConfiguration *)config;
@end

@interface SBIconListView : UIView
@property (nonatomic, strong) SBIconListGridLayout *layout;
@property (nonatomic, strong) SBIconListModel *model;
@property (nonatomic, strong) NSString *iconLocation;
@end

@interface SBFolderIconImageView : UIView
@property (nonatomic, strong, readwrite) UIView *backgroundView;
@end

/*
|====================|
| Global Preferences |
|====================|
*/

BOOL tweakEnabled;

NSString *countText;

NSUInteger rows;
NSUInteger columns;

/*
|======================|
| Portrait Preferences |
|======================|
*/

NSInteger titleOffset_portrait;
NSInteger subtitleOffset_portrait;
NSInteger horizontalIconInset_portrait;
NSInteger topIconInset_portrait;
NSInteger horizontalOffset_portrait;

double titleScale_portrait;
double subtitleScale_portrait;
double titleTransparency_portrait;
double subtitleTransparency_portrait;
double iconScale_portrait;
NSUInteger verticalIconSpacing_portrait;

BOOL homescreenIconBlur_portrait;
BOOL folderBackground_portrait;

/*
|==================================================================|
| Landscape Preferences                                            |
| ---------------------------------------------------------------- |
| The original Bolders had landscape as well.                      |
| However, since landscape is pretty much broken on iOS 14 and 15, |
| Landscape support is not planned at the moment.                  |
|==================================================================|
*/

// NSInteger titleOffset_landscape;
// NSInteger subtitleOffset_landscape;
// NSInteger horizontalIconInset_landscape;
// NSInteger topIconInset_landscape;
// NSInteger horizontalOffset_landscape;

// double titleScale_landscape;
// double subtitleScale_landscape;
// double titleTransparency_landscape;
// double subtitleTransparency_landscape;
// double iconScale_landscape;
// NSUInteger verticalIconSpacing_landscape;

// BOOL homescreenIconBlur_landscape;
// BOOL folderBackground_landscape;
id lastIconSuccess;