#import <UIKit/UIKit.h>
#import <spawn.h>
#import <rootless.h>
#import <Preferences/PSSpecifier.h>
#import "BoldersRebornBaseController.h"
#import "TintColors.h"
#import "../Localization.h"

@implementation BoldersRebornBaseController

- (void)viewDidLoad {
	[super viewDidLoad];
	[self _initTopMenu];
}

- (void)localizeSpecifiers {
	NSDictionary *dict = localizationDictionary();

	for (PSSpecifier *specifier in _specifiers) {
		NSString *localized = [dict objectForKey:specifier.name];

		if (localized) {
			NSString *footerTextLocalized = [dict objectForKey:[specifier propertyForKey:@"footerText"]];
			NSString *defaultTextLocalized = [dict objectForKey:[specifier propertyForKey:@"default"]];

			[specifier setProperty:footerTextLocalized forKey:@"footerText"];
			[specifier setProperty:defaultTextLocalized forKey:@"default"];
			specifier.name = localized;
		}
	}

	NSString *origTitle = self.title;
	self.title = [dict objectForKey:origTitle];
}

- (void)_initTopMenu {
	__weak typeof(self) weakSelf = self;

	NSDictionary *dict = localizationDictionary();

	UIButton *topMenuButton = [UIButton buttonWithType:UIButtonTypeCustom];
	topMenuButton.frame = CGRectMake(0,0,26,26);
	[topMenuButton setImage:[[UIImage systemImageNamed:@"gearshape.fill"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
	topMenuButton.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
	topMenuButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
	topMenuButton.tintColor = kTintColor;

	UIAction *respring = [UIAction actionWithTitle:[dict objectForKey:@"RESPRING"] image:[UIImage systemImageNamed:@"arrow.counterclockwise.circle.fill"] identifier:nil handler:^(UIAction *action) {
		[weakSelf _performRespring];
	}];

	UIAction *resetPrefs = [UIAction actionWithTitle:[dict objectForKey:@"RESET_PREFS"] image:[UIImage systemImageNamed:@"arrow.triangle.2.circlepath.circle.fill"] identifier:nil handler:^(UIAction *action) {
		[weakSelf _performResetPrefs];
	}];

	resetPrefs.attributes = UIMenuElementAttributesDestructive;

	NSArray *items = @[respring, resetPrefs];

	topMenuButton.menu = [UIMenu menuWithTitle:@"" children: items];
	topMenuButton.showsMenuAsPrimaryAction = true;

	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:topMenuButton];
}

- (void)_performResetPrefs {
	__weak typeof(self) weakSelf = self;

	NSDictionary *dict = localizationDictionary();

	UIAlertController *alert = [UIAlertController alertControllerWithTitle:[dict objectForKey:@"RESET_PREFERENCES_QUESTION"] message:[dict objectForKey:@"RESET_PREFERENCES_DESCRIPTION"] preferredStyle:UIAlertControllerStyleAlert];

	UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:[dict objectForKey:@"CANCEL"] style:UIAlertActionStyleDefault handler:nil];
	[alert addAction:cancelAction];

	[alert addAction:[UIAlertAction actionWithTitle:[dict objectForKey:@"RESET_RESET"] style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
		[[NSUserDefaults standardUserDefaults] removePersistentDomainForName:@"com.nightwind.boldersrebornprefs"];

		NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"com.nightwind.boldersrebornprefs"];

		[userDefaults setObject:@true forKey:@"tweakEnabled"];
		[userDefaults synchronize];

		[weakSelf _performRespring];
	}]];

	[self presentViewController:alert animated:true completion:nil];
}

- (void)_performRespring {
    pid_t pid;

    const char *args[] = { "killall", "SpringBoard", NULL };
    posix_spawn(&pid, ROOT_PATH("/usr/bin/killall"), NULL, NULL, (char *const *)args, NULL);
}

@end