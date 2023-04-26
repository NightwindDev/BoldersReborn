// Copyright (c) 2023 Nightwind. All rights reserved.

#import "BoldersRebornHeaderCell.h"
NSCache *versionCache = nil;

#define kTintColor [UIColor colorWithRed:0.86 green:0.26 blue:0.31 alpha:1.0]

NSString *getVersion() {
    int isFinal = FINAL; // needed because of the way the macro works

    if (isFinal == 0) {
        return @"Release Candidate X";
    }

    return PACKAGE_VERSION;
}

@implementation BoldersRebornHeaderCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)identifier specifier:(PSSpecifier *)specifier {
    self = [super initWithStyle:style reuseIdentifier:identifier specifier:specifier];

    if (self) {

        UILabel *tweakTitle = [UILabel new];
        tweakTitle.text = [specifier propertyForKey:@"tweakTitle"];
        tweakTitle.font = [UIFont boldSystemFontOfSize:40];
        tweakTitle.textAlignment = NSTextAlignmentCenter;
        tweakTitle.translatesAutoresizingMaskIntoConstraints = false;
        [self.contentView addSubview:tweakTitle];

        [NSLayoutConstraint activateConstraints:@[
            [tweakTitle.widthAnchor constraintEqualToAnchor:self.contentView.widthAnchor],
            [tweakTitle.bottomAnchor constraintEqualToAnchor:self.contentView.centerYAnchor],
            [tweakTitle.centerXAnchor constraintEqualToAnchor:self.contentView.centerXAnchor],
        ]];

        UIImage *image = [UIImage imageNamed:@"pref_icon.png" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil];

        UIImageView *tweakIconImageView = [[UIImageView alloc] initWithImage:image];
        tweakIconImageView.layer.masksToBounds = true;
        tweakIconImageView.layer.cornerRadius = 10.0f;
        tweakIconImageView.translatesAutoresizingMaskIntoConstraints = false;
        [self.contentView addSubview: tweakIconImageView];

        [NSLayoutConstraint activateConstraints:@[
            [tweakIconImageView.widthAnchor constraintEqualToConstant: 50],
            [tweakIconImageView.heightAnchor constraintEqualToConstant: 50],
            [tweakIconImageView.bottomAnchor constraintEqualToAnchor:tweakTitle.topAnchor constant: -10],
            [tweakIconImageView.centerXAnchor constraintEqualToAnchor:self.contentView.centerXAnchor],
        ]];

        UILabel *versionSubtitle = [UILabel new];
        versionSubtitle.text = getVersion();
        versionSubtitle.textColor = UIColor.secondaryLabelColor;
        versionSubtitle.font = [UIFont boldSystemFontOfSize:25];
        versionSubtitle.textAlignment = NSTextAlignmentCenter;
        versionSubtitle.translatesAutoresizingMaskIntoConstraints = false;
        [self.contentView addSubview:versionSubtitle];

        [NSLayoutConstraint activateConstraints:@[
            [versionSubtitle.widthAnchor constraintEqualToAnchor:self.contentView.widthAnchor],
            [versionSubtitle.topAnchor constraintEqualToAnchor:self.contentView.centerYAnchor constant: 2],
            [versionSubtitle.centerXAnchor constraintEqualToAnchor:self.contentView.centerXAnchor],
        ]];

        int on = [[[[NSUserDefaults alloc] initWithSuiteName:@"com.nightwind.boldersrebornprefs"] objectForKey:@"tweakEnabled"] intValue];

        UISwitch *switchCell = [[UISwitch alloc] initWithFrame: CGRectZero];
        switchCell.transform = CGAffineTransformMakeScale(1.5, 1.5);
        switchCell.translatesAutoresizingMaskIntoConstraints = false;
        switchCell.onTintColor = kTintColor;
        switchCell.on = on == 1 ? true : false;
        [switchCell addTarget: self action: @selector(switchTriggered) forControlEvents: UIControlEventValueChanged];
        [self.contentView addSubview: switchCell];

        [NSLayoutConstraint activateConstraints:@[
            [switchCell.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant: -10],
            [switchCell.centerXAnchor constraintEqualToAnchor:self.contentView.centerXAnchor],
        ]];

        [self setControl:switchCell];

    }

    return self;
}

- (void)switchTriggered {
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"com.nightwind.boldersrebornprefs"];

    [userDefaults setObject:@(((UISwitch *)(self.control)).on) forKey:@"tweakEnabled"];
    [userDefaults synchronize];

    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:blur];
    blurView.frame = self._viewControllerForAncestor.view.bounds;
    blurView.alpha = 0;
    [self._viewControllerForAncestor.view addSubview:blurView];

    [UIView animateWithDuration:0.50 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [blurView setAlpha:1.0];
    } completion:^(BOOL finished) {
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
    }];
}

@end