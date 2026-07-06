#import <UIKit/UIKit.h>
#import <rootless.h>

@protocol SBUIActiveOrientationObserver <NSObject>
- (void)activeInterfaceOrientationDidChangeToOrientation:(UIInterfaceOrientation)orientation willAnimateWithDuration:(NSTimeInterval)duration fromOrientation:(UIInterfaceOrientation)previousOrientation;
- (void)activeInterfaceOrientationWillChangeToOrientation:(UIInterfaceOrientation)orientation;
@end

@interface UIView (Undocumented)
- (UIViewController *)_viewControllerForAncestor;
@end

@interface SpringBoard : UIApplication
+ (instancetype)sharedApplication;
- (UIDeviceOrientation)activeInterfaceOrientation;
- (void)addActiveOrientationObserver:(id<SBUIActiveOrientationObserver>)observer;
@end

@interface SBFolderBackgroundView : UIView
@end

@interface SBIconListGridLayoutConfiguration : NSObject
@property (nonatomic, assign) BOOL isOldFolder;
@property (nonatomic, assign) BOOL check;

- (BOOL)checkIfFolder;
- (void)setNumberOfPortraitColumns:(NSUInteger)numberOfPortraitColumns;
- (NSUInteger)numberOfPortraitColumns;
- (void)setNumberOfPortraitRows:(NSUInteger)numberOfPortraitRows;
- (NSUInteger)numberOfPortraitRows;
@end

@interface _UITextLayoutCanvasView : UIView
@end

@interface _UITextFieldClearButton : UIButton
@end

@interface SBFolderTitleTextField : UITextField <SBUIActiveOrientationObserver>
@property (nonatomic, strong) _UITextLayoutCanvasView *_textCanvasView;
@property (nonatomic, strong) UIView *_backgroundView;
@property (nonatomic, strong) _UITextFieldClearButton *_clearButton;
@property (nonatomic, strong) UILabel *_br_appCountLabel;
@property (nonatomic, strong) NSLayoutConstraint *_br_newConstraint;
@property (nonatomic, strong) NSNumberFormatter *_br_numberFormatter;
- (void)_br_updateIconCount;
- (BOOL)showingEditUI;
@end

@interface SBFolder : NSObject
@property (nonatomic, assign) NSUInteger iconCount;
@property (nonatomic, strong) NSString *displayName;
@end

@interface SBFloatyFolderView : UIView <SBUIActiveOrientationObserver>
@property (nonatomic, strong, readonly, getter=_titleTextField) SBFolderTitleTextField *titleTextField;
@property (nonatomic, strong) UIView *scalingView;
@property (nonatomic, strong) SBFolder *folder;
- (void)_updateScalingViewFrame;
@end

@interface SBFloatyFolderController : NSObject
@property (nonatomic, strong) SBFloatyFolderView *folderView;
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
@end

@interface SBFolderIconImageCache : NSObject
@property (nonatomic, strong) SBIconListGridLayout *listLayout;
@end

@interface SBIconView : UIView
@property (nonatomic, assign, readwrite, getter=isIconContentScalingEnabled) BOOL iconContentScalingEnabled;
- (NSString *)location;
- (void)setIconContentScale:(CGFloat)scale;
@end

@interface SBIconListPageControl : UIView
@end

@interface SBIconListFlowExtendedLayout : NSObject
@property (nonatomic, strong) SBIconListGridLayoutConfiguration *layoutConfiguration;
@end

@interface SBIconListView : UIView
@property (nonatomic, strong) SBIconListGridLayout *layout;
@property (nonatomic, strong) SBIconListModel *model;
@property (nonatomic, strong) NSString *iconLocation;
@end

@interface SBFolderIconImageView : UIView
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

double titleScale;
double subtitleScale;
double titleTransparency;
double subtitleTransparency;
double iconScale;

BOOL homescreenIconBlur;
BOOL folderBackground;

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
NSUInteger verticalIconSpacing_portrait;

/*
|=======================|
| Landscape Preferences |
|=======================|
*/

NSInteger titleOffset_landscape;
NSInteger subtitleOffset_landscape;
NSInteger horizontalIconInset_landscape;
NSInteger topIconInset_landscape;
NSInteger horizontalOffset_landscape;
NSUInteger verticalIconSpacing_landscape;