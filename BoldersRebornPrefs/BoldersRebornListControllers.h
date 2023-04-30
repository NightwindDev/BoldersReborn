#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>
#import <Preferences/PSTableCell.h>
#import <Preferences/PSSwitchTableCell.h>
#import <Preferences/PSSliderTableCell.h>
#import <LocalAuthentication/LocalAuthentication.h>
#import <substrate.h>
#import <spawn.h>
#import "rootless.h"

@interface PSSegmentTableCell : PSControlTableCell {

	NSArray* _values;
	NSDictionary* _titleDict;
}
-(id)newControl;
-(id)controlValue;
-(void)setValues:(id)arg1 titleDictionary:(id)arg2 ;
-(id)initWithStyle:(long long)arg1 reuseIdentifier:(id)arg2 specifier:(id)arg3 ;
-(void)refreshCellContentsWithSpecifier:(id)arg1 ;
-(BOOL)canReload;
-(void)layoutSubviews;
-(id)titleLabel;
-(void)prepareForReuse;
-(void)setValue:(id)arg1 ;
@end

@interface PSSliderTableCell (Private)
- (float)controlValue;
@end

@interface BoldersRebornRootListController : PSListController
@end

@interface BoldersRebornPortraitController : PSListController
@end

@interface BoldersRebornLandscapeController : PSListController
@end

@interface BoldersRebornInfoController : UIViewController
@property (nonatomic, weak) NSString *infoTitle;
@property (nonatomic, strong) NSString *offInfoDescription;
@property (nonatomic, strong) NSString *onInfoDescription;
@property (nonatomic, weak) NSString *dismissAndApply;
@property (nonatomic, weak) UIImage *infoImage;
@property (nonatomic, weak) PSSwitchTableCell *caller;
@end

UIBarButtonItem *topMenuButtonItem;
UIButton *dismissTopMenuButton;
