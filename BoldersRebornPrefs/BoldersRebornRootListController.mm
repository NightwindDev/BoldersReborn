// Copyright (c) 2024 Nightwind. All rights reserved.

#import "BoldersRebornRootListController.h"
#import "TintColors.h"
#import <rootless.h>

@implementation BoldersRebornRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];

		if (![self _deviceLanguageIsSupported]) {
			NSString *langName = [[NSLocale.currentLocale localizedStringForLanguageCode:NSLocale.currentLocale.languageCode] capitalizedString];
			NSString *error = [NSString stringWithFormat:@"The %@ language is not currently supported. Click here to help translate it!", langName];
			NSRange range = [error rangeOfString:@"here"];
			NSString *locationOfHere = [NSString stringWithFormat:@"{%lu, %lu}", range.location, range.length];

			[_specifiers addObject:({
				PSSpecifier *specifier = [PSSpecifier emptyGroupSpecifier];

				[specifier setProperty:@"PSFooterHyperlinkView" forKey:@"footerCellClass"];
				[specifier setProperty:@"openTranslationSite" forKey:@"footerHyperlinkAction"];
				[specifier setProperty:error forKey:@"headerFooterHyperlinkButtonTitle"];
				[specifier setProperty:locationOfHere forKey:@"footerHyperlinkRange"];
				[specifier setProperty:[NSValue valueWithNonretainedObject:self] forKey:@"footerHyperlinkTarget"];

				specifier;
			})];
		}

		[self localizeSpecifiers];
	}

	return _specifiers;
}

- (void)openTranslationSite {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/NightwindDev/BoldersReborn/blob/main/Translation.md"] options:@{} completionHandler:nil];
}

- (void)_returnKeyPressed:(id)arg1 {
    [self.view endEditing:YES];
}

- (instancetype)init {
    self = [super init];

    if (self) {
		NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"com.nightwind.boldersrebornprefs"];

		if (![userDefaults objectForKey:@"tweakEnabled"]) {
			[userDefaults setObject:@(true) forKey:@"tweakEnabled"];
			[userDefaults synchronize];
		}
    }

    return self;
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

- (void)viewDidLoad {
    [super viewDidLoad];

    UITapGestureRecognizer *tapper = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    tapper.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapper];

	NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"com.nightwind.boldersrebornprefs"];

	if (![self _deviceLanguageIsSupported] && ![[userDefaults objectForKey:@"initialAlertWasShown"] isEqual:@(true)]) {
		NSString *title = @"Your device's language is not supported.\nHowever...";
		NSString *message = @"You can either help with translating Bolders Reborn to your language, or continue to use the tweak in English.\n\nDo note that if you want to use English and then reconsider later, you will be able to submit a translation in the bottom of the main page of the settings of the tweak.";

		UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];

		[alert addAction:[UIAlertAction actionWithTitle:@"Help With Translation" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
			[self openTranslationSite];
		}]];

		UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Keep Using English" style:UIAlertActionStyleDestructive handler:nil];
		[alert addAction:cancelAction];

		[self presentViewController:alert animated:true completion:nil];

		[userDefaults setObject:@(true) forKey:@"initialAlertWasShown"];
		[userDefaults synchronize];
	}
}

- (void)handleSingleTap:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
}

- (PSTableCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	PSTableCell *cell = (PSTableCell *)[super tableView:tableView cellForRowAtIndexPath:indexPath];

	if (indexPath.row == 0 && indexPath.section == 0) {
		cell.backgroundColor = UIColor.clearColor;
	}

	if (cell.specifier.cellType == 9) {
		PSControlTableCell *segmentTableCell = (PSControlTableCell *)cell;
		NSDictionary *dict = [segmentTableCell valueForKey:@"_titleDict"];
		NSMutableDictionary *mutableDict = [dict mutableCopy];

		for (NSString *num in dict) {
			NSNumberFormatter *numberFormatter = [NSNumberFormatter new];
			numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
			NSString *countString = [numberFormatter stringFromNumber:@([num intValue])];
			[mutableDict setValue:countString forKey:num];
		}

		segmentTableCell.specifier.titleDictionary = mutableDict;
		[segmentTableCell refreshCellContentsWithSpecifier:segmentTableCell.specifier];
	}

	return cell;
}

- (BOOL)_deviceLanguageIsSupported {
	NSString *const genericPath = ROOT_PATH_NS(@"/Library/PreferenceBundles/BoldersRebornPrefs.bundle/Localization/LANG.lproj/Localization.strings");
	NSString *const filePath = [genericPath stringByReplacingOccurrencesOfString:@"LANG" withString:NSLocale.currentLocale.languageCode];
	return [[NSFileManager defaultManager] fileExistsAtPath:filePath];
}

- (void)setTitle:(NSString *)title {}

@end
