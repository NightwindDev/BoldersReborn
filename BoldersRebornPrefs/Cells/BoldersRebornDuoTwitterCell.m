// Copyright (c) 2023 Nightwind. All rights reserved.

#import "BoldersRebornDuoTwitterCell.h"

@interface BoldersSingleTwitterView : UIButton
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *handle;
@property (nonatomic, strong) NSString *openURL;
@end

@implementation BoldersSingleTwitterView {
    UIImageView *leftImageView;
    UILabel *usernameLabel;
    UILabel *handleLabel;
    BOOL subviewsAdded;
}

- (void)didMoveToWindow {
    [super didMoveToWindow];

    if (!subviewsAdded) {
        subviewsAdded = true;

        self.translatesAutoresizingMaskIntoConstraints = false;

        UIImage *image = [UIImage imageNamed:self.url inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil];

        leftImageView = [[UIImageView alloc] initWithImage:image];
        leftImageView.layer.masksToBounds = true;
        leftImageView.layer.cornerRadius = 10.0f;
        leftImageView.translatesAutoresizingMaskIntoConstraints = false;
        [self addSubview: leftImageView];

        usernameLabel = [UILabel new];
        usernameLabel.text = self.username;
        usernameLabel.font = [UIFont boldSystemFontOfSize:15];
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false;
        [self addSubview:usernameLabel];

        handleLabel = [UILabel new];
        handleLabel.text = self.handle;
        handleLabel.textColor = UIColor.secondaryLabelColor;
        handleLabel.font = [UIFont systemFontOfSize:13];
        handleLabel.translatesAutoresizingMaskIntoConstraints = false;
        [self addSubview:handleLabel];

        [self addTarget:self action:@selector(open) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];

    [NSLayoutConstraint activateConstraints:@[
        [leftImageView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
        [leftImageView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:15],
        [leftImageView.heightAnchor constraintEqualToConstant:40],
        [leftImageView.widthAnchor constraintEqualToConstant:40],

        [usernameLabel.topAnchor constraintEqualToAnchor:self.centerYAnchor constant: -18],
        [usernameLabel.leadingAnchor constraintEqualToAnchor:leftImageView.trailingAnchor constant:10],
        [usernameLabel.heightAnchor constraintEqualToConstant:20],

        [handleLabel.bottomAnchor constraintEqualToAnchor:self.centerYAnchor constant: 18],
        [handleLabel.leadingAnchor constraintEqualToAnchor:leftImageView.trailingAnchor constant:10],
        [handleLabel.heightAnchor constraintEqualToConstant:20],
    ]];
}

- (void)open {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.openURL] options:@{} completionHandler:nil];
}

@end

@implementation BoldersRebornDuoTwitterCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)identifier specifier:(PSSpecifier *)specifier {
    self = [super initWithStyle:style reuseIdentifier:identifier specifier:specifier];

    if (self) {

        BoldersSingleTwitterView *leftSide = [BoldersSingleTwitterView new];
        leftSide.username = [specifier propertyForKey:@"leftUsername"];
        leftSide.handle = [specifier propertyForKey:@"leftHandle"];
        leftSide.url = [specifier propertyForKey:@"leftProfilePicture"];
        leftSide.openURL = [specifier propertyForKey:@"leftOpenURL"];
        [self.contentView addSubview:leftSide];

        [NSLayoutConstraint activateConstraints:@[
            [leftSide.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor],
            [leftSide.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor],
            [leftSide.heightAnchor constraintEqualToAnchor:self.contentView.heightAnchor],
            [leftSide.widthAnchor constraintEqualToAnchor:self.contentView.widthAnchor multiplier:0.5],
        ]];

        // -------------------------------------------- //

        BoldersSingleTwitterView *rightSide = [BoldersSingleTwitterView new];
        rightSide.username = [specifier propertyForKey:@"rightUsername"];
        rightSide.handle = [specifier propertyForKey:@"rightHandle"];
        rightSide.url = [specifier propertyForKey:@"rightProfilePicture"];
        rightSide.openURL = [specifier propertyForKey:@"rightOpenURL"];
        [self.contentView addSubview:rightSide];

        [NSLayoutConstraint activateConstraints:@[
            [rightSide.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor],
            [rightSide.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor],
            [rightSide.heightAnchor constraintEqualToAnchor:self.contentView.heightAnchor],
            [rightSide.widthAnchor constraintEqualToAnchor:self.contentView.widthAnchor multiplier:0.5],
        ]];

        // -------------------------------------------- //

        UIView *separator = [UIView new];
        separator.translatesAutoresizingMaskIntoConstraints = false;
        separator.backgroundColor = UIColor.tertiaryLabelColor;
        separator.alpha = 0.8;
        separator.layer.masksToBounds = true;
        separator.layer.cornerRadius = 0.5;
        [self.contentView addSubview:separator];

        [NSLayoutConstraint activateConstraints:@[
            [separator.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor],
            [separator.centerXAnchor constraintEqualToAnchor:self.contentView.centerXAnchor],
            [separator.heightAnchor constraintEqualToAnchor:self.contentView.heightAnchor multiplier: 0.7],
            [separator.widthAnchor constraintEqualToConstant:1],
        ]];

    }


    return self;
}

@end