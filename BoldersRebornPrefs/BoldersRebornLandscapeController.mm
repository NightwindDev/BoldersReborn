#import <Preferences/PSControlTableCell.h>
#import "BoldersRebornLandscapeController.h"
#import "TintColors.h"

@implementation BoldersRebornLandscapeController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Landscape" target:self];
		[self localizeSpecifiers];
	}

	return _specifiers;
}

- (PSControlTableCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	PSControlTableCell *cell = (PSControlTableCell *)[super tableView:tableView cellForRowAtIndexPath:indexPath];

	cell.tintColor = kTintColor;

	if ([cell.control isKindOfClass:[UISwitch class]]) {
		UISwitch *cellSwitch = (UISwitch *)cell.control;
		cellSwitch.onTintColor = kTintColor;
	}

	return cell;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];

	self.navigationController.navigationBar.tintColor = kTintColor;
	self.navigationController.navigationController.navigationBar.tintColor = kTintColor;
}

@end