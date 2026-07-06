include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = BoldersRebornPrefs

BoldersRebornPrefs_FILES = BoldersRebornRootListController.mm BoldersRebornBaseController.mm BoldersRebornInfoController.mm BoldersRebornPortraitController.mm BoldersRebornLandscapeController.mm BoldersRebornHomescreenController.mm ../Localization.m $(wildcard Cells/*.m Cells/*.mm)
BoldersRebornPrefs_FRAMEWORKS = UIKit
BoldersRebornPrefs_PRIVATE_FRAMEWORKS = Preferences
BoldersRebornPrefs_INSTALL_PATH = /Library/PreferenceBundles
BoldersRebornPrefs_CFLAGS = -fobjc-arc -DPACKAGE_VERSION='@"$(THEOS_PACKAGE_BASE_VERSION)"'

include $(THEOS_MAKE_PATH)/bundle.mk