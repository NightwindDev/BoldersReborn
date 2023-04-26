// Copyright (c) 2023 Nightwind. All rights reserved.

#import "BoldersRebornListControllers.h"

#define kTintColor [UIColor colorWithRed:0.86 green:0.26 blue:0.31 alpha:1.0]
#define kSelectedTintColor [UIColor colorWithRed:0.84 green:0.44 blue:0.47 alpha:1.0]
#define lang [NSLocale.currentLocale.localeIdentifier substringToIndex:2]

@interface UINavigationItem (Private)
@property (nonatomic, weak, readwrite) UINavigationBar *navigationBar;
@end

void respring() {
    extern char **environ;
    pid_t pid;

    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = @[@"/var/LIY", @"/var/Liy", @"/var/liy"];

    for (NSString *path in paths) {
        BOOL isDirectory;
        if ([fileManager fileExistsAtPath:path isDirectory:&isDirectory] && isDirectory) {
            const char *args[] = {"killall", "backboardd", NULL};
            posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char *const *)args, environ);
            return;
        }
    }

    const char *args[] = {"sbreload", NULL};
    posix_spawn(&pid, ROOT_PATH("/usr/bin/sbreload"), NULL, NULL, (char *const *)args, environ);
}

void performRespringFromController(UIViewController *controller) {
	UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
	UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:blur];
	blurView.frame = controller.view.bounds;
	blurView.alpha = 0;
	[controller.view addSubview:blurView];

	[UIView animateWithDuration:0.50 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
		[blurView setAlpha:1.0];
	} completion:^(BOOL finished) {
		[controller.view endEditing:YES];
		respring();
	}];
}

void performResetPrefsFromController(UIViewController *controller) {
	NSString *genericPath = ROOT_PATH_NS(@"/Library/PreferenceBundles/BoldersRebornPrefs.bundle/Localization/LANG.lproj/Localization.strings");
	NSString *filePath = [genericPath stringByReplacingOccurrencesOfString:@"LANG" withString:lang];

	NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:filePath];


	UIAlertController *alert = [UIAlertController alertControllerWithTitle:[dict objectForKey:@"RESET_PREFERENCES_QUESTION"] message:[dict objectForKey:@"RESET_PREFERENCES_DESCRIPTION"] preferredStyle:UIAlertControllerStyleAlert];

	UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:[dict objectForKey:@"CANCEL"] style:UIAlertActionStyleDefault handler:nil];
	[alert addAction:cancelAction];

	[alert addAction:[UIAlertAction actionWithTitle:[dict objectForKey:@"RESET_RESET"] style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
		[[NSUserDefaults standardUserDefaults] removePersistentDomainForName:@"com.nightwind.boldersrebornprefs"];

		NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"com.nightwind.boldersrebornprefs"];

		[userDefaults setObject:@true forKey:@"tweakEnabled"];
		[userDefaults synchronize];

		UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
		UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:blur];
		blurView.frame = controller.view.bounds;
		blurView.alpha = 0;
		[controller.view addSubview:blurView];

		[UIView animateWithDuration:0.50 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
			[blurView setAlpha:1.0];
		} completion:^(BOOL finished) {
			[controller.view endEditing:YES];
			respring();
		}];
	}]];

	[controller presentViewController:alert animated:true completion:nil];
}

void localize(PSListController *controller, NSArray *_specifiers) {
	NSString *genericPath = ROOT_PATH_NS(@"/Library/PreferenceBundles/BoldersRebornPrefs.bundle/Localization/LANG.lproj/Localization.strings");
	NSString *filePath = [genericPath stringByReplacingOccurrencesOfString:@"LANG" withString:lang];

	NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:filePath];

	for (PSSpecifier *specifier in _specifiers) {
		NSString *origName = specifier.name;

		NSString *loc = [dict objectForKey:origName];
		NSString *footerTextLoc = [dict objectForKey:[specifier propertyForKey:@"footerText"]];
		NSString *defaultTextLoc = [dict objectForKey:[specifier propertyForKey:@"default"]];

		[specifier setProperty:footerTextLoc forKey:@"footerText"];
		[specifier setProperty:defaultTextLoc forKey:@"default"];
		specifier.name = loc;
	}

	NSString *origTitle = controller.title;
	controller.title = [dict objectForKey:origTitle];
}


NSString *localizedCountString(NSUInteger count) {
    NSNumberFormatter *numberFormatter = [NSNumberFormatter new];
    numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    NSString *countString = [numberFormatter stringFromNumber:[NSNumber numberWithUnsignedLong:count]];
    return countString;
}


@implementation BoldersRebornRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];

		NSString *genericPath = ROOT_PATH_NS(@"/Library/PreferenceBundles/BoldersRebornPrefs.bundle/Localization/LANG.lproj/Localization.strings");
		NSString *filePath = [genericPath stringByReplacingOccurrencesOfString:@"LANG" withString:lang];

		NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:filePath];

		[_specifiers addObject:({
			PSSpecifier *specifier = [PSSpecifier preferenceSpecifierNamed:NULL
																	target:self
																	set:NULL
																	get:NULL
																	detail:NULL
																	cell:PSGroupCell
																	edit:nil];

			[specifier setProperty:strcmp(THEOS_PACKAGE_INSTALL_PREFIX, "/var/jb") == 0 ? @"BUILD_ROOTLESS" : @"BUILD_ROOTFUL" forKey:@"footerText"];
			[specifier setProperty:@1 forKey:@"footerAlignment"];


			specifier;
		})];

		localize(self, _specifiers);
	}

	return _specifiers;
}

-(void)_returnKeyPressed:(id)arg1 {
    [self.view endEditing:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PSTableCell *cell = (PSTableCell *)[tableView cellForRowAtIndexPath:indexPath];

    PSSpecifier *specifier = [cell specifier];
    NSString *specifierIdentifier = [specifier identifier];

    if ([specifierIdentifier isEqualToString:@"RESET_PREFS"]) {
        performResetPrefsFromController(self);
    } else {
        [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
}

- (void)initTopMenu {
	NSString *genericPath = ROOT_PATH_NS(@"/Library/PreferenceBundles/BoldersRebornPrefs.bundle/Localization/LANG.lproj/Localization.strings");
	NSString *filePath = [genericPath stringByReplacingOccurrencesOfString:@"LANG" withString:lang];

	NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:filePath];

	UIButton *topMenuButton = [UIButton buttonWithType:UIButtonTypeCustom];
	topMenuButton.frame = CGRectMake(0,0,26,26);
	[topMenuButton setImage:[[UIImage systemImageNamed:@"gearshape.fill"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
	topMenuButton.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
	topMenuButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
	topMenuButton.tintColor = kTintColor;

	UIAction *respring = [UIAction actionWithTitle:[dict objectForKey:@"RESPRING"]
													image:[UIImage systemImageNamed:@"arrow.counterclockwise.circle.fill"]
												identifier:nil
												handler:^(UIAction *action) {
		performRespringFromController(self);
	}];

	UIAction *resetPrefs = [UIAction actionWithTitle:[dict objectForKey:@"RESET_PREFS"]
													image:[UIImage systemImageNamed:@"arrow.triangle.2.circlepath.circle.fill"]
												identifier:nil
													handler:^(UIAction *action) {
		performResetPrefsFromController(self);
	}];

	resetPrefs.attributes = UIMenuElementAttributesDestructive;

	NSArray *items = @[respring, resetPrefs];

	topMenuButton.menu = [UIMenu menuWithTitle:@"" children: items];
	topMenuButton.showsMenuAsPrimaryAction = true;

	topMenuButtonItem = [[UIBarButtonItem alloc] initWithCustomView:topMenuButton];

	self.navigationItem.rightBarButtonItem = topMenuButtonItem;
}

- (void)viewDidLoad {
	[super viewDidLoad];

	[self initTopMenu];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];

	self.navigationController.navigationBar.tintColor = kTintColor;
	self.navigationController.navigationController.navigationBar.tintColor = kTintColor;
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillAppear:animated];

	self.navigationController.navigationBar.tintColor = UIColor.systemBlueColor;
	self.navigationController.navigationController.navigationBar.tintColor = UIColor.systemBlueColor;
}

- (PSTableCell *)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
	PSTableCell *cell = (PSTableCell *)[super tableView:tableView cellForRowAtIndexPath:indexPath];

	if (indexPath.row == 0 && indexPath.section == 0) {
		cell.backgroundColor = UIColor.clearColor;
	}

	if (cell.specifier.cellType == 9) {
		PSSegmentTableCell *segmentTableCell = (PSSegmentTableCell *)cell;
		NSDictionary *dict = [segmentTableCell valueForKey:@"_titleDict"];
		NSMutableDictionary *mutableDict = [dict mutableCopy];

		for (NSString *num in dict) {
			[mutableDict setValue:localizedCountString([num intValue]) forKey:num];
		}

		segmentTableCell.specifier.titleDictionary = mutableDict;
		[segmentTableCell refreshCellContentsWithSpecifier:segmentTableCell.specifier];
	}

	return cell;
}

- (void)respring {
	performRespringFromController(self);
}

@end

@implementation BoldersRebornPortraitController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Portrait" target:self];

		localize(self, _specifiers);
	}

	return _specifiers;
}

- (void)initTopMenu {
	NSString *genericPath = ROOT_PATH_NS(@"/Library/PreferenceBundles/BoldersRebornPrefs.bundle/Localization/LANG.lproj/Localization.strings");
	NSString *filePath = [genericPath stringByReplacingOccurrencesOfString:@"LANG" withString:lang];

	NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:filePath];

	UIButton *topMenuButton = [UIButton buttonWithType:UIButtonTypeCustom];
	topMenuButton.frame = CGRectMake(0,0,26,26);
	[topMenuButton setImage:[[UIImage systemImageNamed:@"gearshape.fill"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
	topMenuButton.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
	topMenuButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
	topMenuButton.tintColor = kTintColor;

	UIAction *respring = [UIAction actionWithTitle:[dict objectForKey:@"RESPRING"]
													image:[UIImage systemImageNamed:@"arrow.counterclockwise.circle.fill"]
												identifier:nil
												handler:^(UIAction *action) {
		performRespringFromController(self);
	}];

	UIAction *resetPrefs = [UIAction actionWithTitle:[dict objectForKey:@"RESET_PREFS"]
													image:[UIImage systemImageNamed:@"arrow.triangle.2.circlepath.circle.fill"]
												identifier:nil
													handler:^(UIAction *action) {
		performResetPrefsFromController(self);
	}];

	resetPrefs.attributes = UIMenuElementAttributesDestructive;

	NSArray *items = @[respring, resetPrefs];

	topMenuButton.menu = [UIMenu menuWithTitle:@"" children: items];
	topMenuButton.showsMenuAsPrimaryAction = true;

	topMenuButtonItem = [[UIBarButtonItem alloc] initWithCustomView:topMenuButton];

	self.navigationItem.rightBarButtonItem = topMenuButtonItem;
}

- (PSControlTableCell *)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
	PSControlTableCell *cell = (PSControlTableCell *)[super tableView:tableView cellForRowAtIndexPath:indexPath];

	cell.tintColor = kTintColor;

	if ([cell.control isKindOfClass:NSClassFromString(@"UISwitch")]) {
		UISwitch *cellSwitch = (UISwitch *)cell.control;
		cellSwitch.onTintColor = kTintColor;
	}

	return cell;
}

- (void)viewDidLoad {
	[super viewDidLoad];

	[self initTopMenu];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];

	self.navigationController.navigationBar.tintColor = kTintColor;
	self.navigationController.navigationController.navigationBar.tintColor = kTintColor;
}

- (void)respring {
	performRespringFromController(self);
}

@end


@implementation BoldersRebornInfoController {
    UIImageView *_imageView;
    UILabel *_description;
}

- (void)viewDidLoad {
	[super viewDidLoad];

	BOOL isOn = ((UISwitch *)(self.caller.control)).isOn;

	self.view.backgroundColor = UIColor.systemBackgroundColor;

	_imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:(isOn ? @"no_icon_blur.png" : @"icon_blur.png") inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil]];
	_imageView.layer.masksToBounds = true;
	_imageView.layer.cornerRadius = 10.0f;
	_imageView.translatesAutoresizingMaskIntoConstraints = false;
	_imageView.contentMode = UIViewContentModeScaleAspectFit;
	_imageView.alpha = 0.8;

	CAGradientLayer *gradient = [CAGradientLayer layer];
	gradient.frame = _imageView.bounds;
	gradient.colors = @[(id)UIColor.clearColor.CGColor, (id)UIColor.systemBackgroundColor.CGColor];

	CAShapeLayer *mask = [CAShapeLayer layer];
	mask.frame = _imageView.bounds;
	mask.path = [UIBezierPath bezierPathWithRect:_imageView.bounds].CGPath;
	mask.fillColor = UIColor.blackColor.CGColor;
	mask.strokeColor = UIColor.clearColor.CGColor;
	mask.lineWidth = 0;

	gradient.mask = mask;

	[_imageView.layer addSublayer:gradient];

	[self.view addSubview: _imageView];

	[NSLayoutConstraint activateConstraints:@[
		[_imageView.widthAnchor constraintEqualToAnchor: self.view.widthAnchor],
		[_imageView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor],
		[_imageView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
	]];

	UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
	closeButton.translatesAutoresizingMaskIntoConstraints = NO;
	closeButton.backgroundColor = kTintColor;
	closeButton.layer.cornerRadius = 10;
	[closeButton setTitle:self.dismissAndApply forState:UIControlStateNormal];
	[closeButton addTarget:self action:@selector(closeButtonTapped) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:closeButton];

	[NSLayoutConstraint activateConstraints:@[
		[closeButton.widthAnchor constraintEqualToAnchor:self.view.widthAnchor multiplier:0.85],
		[closeButton.heightAnchor constraintEqualToConstant: 50],
		[closeButton.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:-35],
		[closeButton.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
	]];

	_description = [UILabel new];
	_description.text = isOn ? self.onInfoDescription : self.offInfoDescription;
	_description.textColor = UIColor.whiteColor;
	_description.font = [UIFont systemFontOfSize:20];
	_description.textAlignment = NSTextAlignmentCenter;
	_description.lineBreakMode = NSLineBreakByWordWrapping;
	_description.numberOfLines = 0;
	_description.translatesAutoresizingMaskIntoConstraints = false;
	[self.view addSubview:_description];

	[NSLayoutConstraint activateConstraints:@[
		[_description.bottomAnchor constraintEqualToAnchor:closeButton.topAnchor constant:-30],
		[_description.widthAnchor constraintEqualToAnchor:self.view.widthAnchor multiplier:0.95],
		[_description.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
	]];

	UILabel *infoTitle = [UILabel new];
	infoTitle.text = self.infoTitle;
	infoTitle.textColor = UIColor.whiteColor;
	infoTitle.font = [UIFont boldSystemFontOfSize:27];
	infoTitle.textAlignment = NSTextAlignmentCenter;
	infoTitle.translatesAutoresizingMaskIntoConstraints = false;
	[self.view addSubview:infoTitle];

	[NSLayoutConstraint activateConstraints:@[
		[infoTitle.bottomAnchor constraintEqualToAnchor:_description.topAnchor constant: -10],
		[infoTitle.widthAnchor constraintEqualToAnchor:self.view.widthAnchor],
		[infoTitle.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
	]];

	UISwitch *switchCell = [[UISwitch alloc] initWithFrame: CGRectZero];
	switchCell.transform = CGAffineTransformMakeScale(1.5, 1.5);
	switchCell.translatesAutoresizingMaskIntoConstraints = false;
	switchCell.onTintColor = kTintColor;
	switchCell.on = isOn;
	[switchCell addTarget: self action: @selector(switchTriggered:) forControlEvents: UIControlEventValueChanged];
	[self.view addSubview: switchCell];

	[NSLayoutConstraint activateConstraints:@[
		[switchCell.bottomAnchor constraintEqualToAnchor:infoTitle.topAnchor constant: -30],
		[switchCell.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
	]];
}

- (void)closeButtonTapped {
	[self dismissViewControllerAnimated:true completion:nil];
}

- (void)switchTriggered:(UISwitch *)sender {
    UIImage *newImage = nil;
    NSString *newText = nil;

    if (sender.isOn) {
        newImage = [UIImage imageNamed:@"no_icon_blur.png" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil];
        newText = self.onInfoDescription;
    } else {
        newImage = [UIImage imageNamed:@"icon_blur.png" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil];
        newText = self.offInfoDescription;
    }

    [UIView transitionWithView:_imageView
                      duration:0.3
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        _imageView.image = newImage;
                    }
                    completion:nil];

    CATransition *textTransition = [CATransition animation];
    textTransition.duration = 0.3;
    textTransition.type = kCATransitionFade;
    [_description.layer addAnimation:textTransition forKey:nil];
    _description.text = newText;

	[(UISwitch *)(self.caller.control) setOn:sender.isOn animated:true];
}


@end

/*
|==================================================================|
| Landscape Preferences                                            |
| - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  |
| The original Bolders had landscape as well.                      |
| However, since landscape is pretty much broken on iOS 14 and 15, |
| Landscape support is not planned at the moment.                  |
|==================================================================|
*/

// @implementation BoldersRebornLandscapeController

// - (NSArray *)specifiers {
// 	if (!_specifiers) {
// 		_specifiers = [self loadSpecifiersFromPlistName:@"Landscape" target:self];
// 	}

// 	return _specifiers;
// }

// @end
