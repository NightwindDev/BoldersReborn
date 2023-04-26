// Copyright (c) 2023 Nightwind. All rights reserved.

#import "BoldersRebornInfoSwitchCell.h"

@implementation BoldersRebornInfoSwitchCell {
  UIButton *infoButton;
  BOOL isOpenOn;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)identifier specifier:(PSSpecifier *)specifier {
    self = [super initWithStyle:style reuseIdentifier:identifier specifier:specifier];

    if(self) {
        infoButton = [UIButton buttonWithType:UIButtonTypeInfoDark];
        infoButton.translatesAutoresizingMaskIntoConstraints = NO;
        [infoButton addTarget:self action:@selector(infoButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:infoButton];

        [NSLayoutConstraint activateConstraints:@[
            [infoButton.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor],
            [infoButton.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-4],
        ]];
    }


    return self;
}

- (void)infoButtonTapped {
    __weak __typeof__(self) weakSelf = self;

	NSString *genericPath = ROOT_PATH_NS(@"/Library/PreferenceBundles/BoldersRebornPrefs.bundle/Localization/LANG.lproj/Localization.strings");
	NSString *filePath = [genericPath stringByReplacingOccurrencesOfString:@"LANG" withString:[NSLocale.currentLocale.localeIdentifier substringToIndex:2]];

	NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:filePath];

    BoldersRebornInfoController *controller = [BoldersRebornInfoController new];
    controller.modalPresentationStyle = UIModalPresentationFormSheet;
    controller.infoTitle = [dict objectForKey:@"HOMESCREEN_BLUR"];
    controller.offInfoDescription = [dict objectForKey:@"HOMESCREEN_ICON_BLUR_OFF_INFO_DESCRIPTION"];
    controller.onInfoDescription = [dict objectForKey:@"HOMESCREEN_ICON_BLUR_ON_INFO_DESCRIPTION"];
    controller.dismissAndApply = [dict objectForKey:@"DISMISS_AND_APPLY"];
    controller.caller = weakSelf;

    UIViewController *rootViewController = self._viewControllerForAncestor;
    [rootViewController presentViewController:controller animated:YES completion:nil];
}

- (void)tintColorDidChange {
    [super tintColorDidChange];

    infoButton.tintColor = self.tintColor;
}

- (void)refreshCellContentsWithSpecifier:(PSSpecifier *)specifier {
    [super refreshCellContentsWithSpecifier:specifier];

    if([self respondsToSelector:@selector(tintColor)]) {
        infoButton.tintColor = self.tintColor;
    }
}

- (void)controlChanged:(id)on {
    [super controlChanged:on];

    isOpenOn = !isOpenOn;
}

@end