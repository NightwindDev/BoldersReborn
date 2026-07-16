#import <Foundation/Foundation.h>
#import <rootless.h>

NSDictionary *localizationDictionary(void) {
	static NSDictionary *bundleDictionary = nil;
	static dispatch_once_t onceToken;

	dispatch_once(&onceToken, ^{
		NSString *const locDir = ROOT_PATH_NS(@"/Library/PreferenceBundles/BoldersRebornPrefs.bundle/Localization");

		NSMutableArray<NSString *> *available = [NSMutableArray new];
		for (NSString *name in [[NSFileManager defaultManager] contentsOfDirectoryAtPath:locDir error:nil]) {
			if ([name hasSuffix:@".lproj"]) {
				[available addObject:name.stringByDeletingPathExtension];
			}
		}

		NSString *best = [NSBundle preferredLocalizationsFromArray:available].firstObject ?: @"en";
		NSString *filePath = [locDir stringByAppendingFormat:@"/%@.lproj/Localization.strings", best];

		if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
			filePath = [locDir stringByAppendingString:@"/en.lproj/Localization.strings"];
		}

		bundleDictionary = [NSDictionary dictionaryWithContentsOfFile:filePath];
	});

	return bundleDictionary;
}
