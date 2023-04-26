// Copyright (c) 2023 Nightwind. All rights reserved.

#import "BoldersRebornSliderCell.h"

NSString *stringFromFloatRoundedToDecimalPlaces(NSUInteger decimalPlaces, float floatValue) {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    formatter.maximumFractionDigits = decimalPlaces;
    formatter.roundingMode = NSNumberFormatterRoundUp;

    return [formatter stringFromNumber:@(floatValue)];
}

@implementation BoldersRebornSliderCell

- (void)layoutSubviews {
    [super layoutSubviews];

    UILabel *label = (UILabel *)self.subviews[0].subviews[0].subviews[0].subviews[0];
    label.translatesAutoresizingMaskIntoConstraints = false;
    [label.centerYAnchor constraintEqualToAnchor: self.contentView.centerYAnchor].active = true;
    [label.rightAnchor constraintEqualToAnchor: self.contentView.rightAnchor constant: -10].active = true;

    MSHookIvar<NSMutableArray *>(self.control, "_gestureRecognizers") = [NSMutableArray new];
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];

	UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped)];
	tapGestureRecognizer.numberOfTapsRequired = 2;
	[self addGestureRecognizer:tapGestureRecognizer];
}

- (void)tapped {

	NSString *genericPath = ROOT_PATH_NS(@"/Library/PreferenceBundles/BoldersRebornPrefs.bundle/Localization/LANG.lproj/Localization.strings");
	NSString *filePath = [genericPath stringByReplacingOccurrencesOfString:@"LANG" withString:[NSLocale.currentLocale.localeIdentifier substringToIndex:2]];

	NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:filePath];

    UISlider *slider = (UISlider *)self.control;
    NSString *minVal = stringFromFloatRoundedToDecimalPlaces(2, slider.minimumValue);
    NSString *maxVal = stringFromFloatRoundedToDecimalPlaces(2, slider.maximumValue);

    NSString *message = [NSString stringWithFormat:@"%@: %@ • %@: %@", [dict objectForKey:@"MIN_VALUE"], minVal, [dict objectForKey:@"MAX_VALUE"], maxVal];

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[dict objectForKey:@"SET_SLIDER_VALUE"] message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = stringFromFloatRoundedToDecimalPlaces(2, [self.controlValue floatValue]);
        textField.placeholder = stringFromFloatRoundedToDecimalPlaces(2, [self.controlValue floatValue]);
        textField.keyboardType = UIKeyboardTypeDecimalPad;
    }];

    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        float textFieldValue = [[[alertController textFields][0] text] floatValue];
        UISlider *slider = (UISlider *)self.control;

        if (textFieldValue) {
            [slider setValue:textFieldValue animated: true];
            NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"com.nightwind.boldersrebornprefs"];

            [userDefaults setObject:@(textFieldValue) forKey:self.specifier.identifier];
            [userDefaults synchronize];
        }

        if (textFieldValue < slider.minimumValue || textFieldValue > slider.maximumValue) {
            action.enabled = false;
        } else {
            action.enabled = true;
        }
    }];

    [alertController addAction:confirmAction];

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:[dict objectForKey:@"CANCEL"] style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];

    [self._viewControllerForAncestor presentViewController:alertController animated:YES completion:nil];
}

@end