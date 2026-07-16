export TARGET := iphone:clang:16.5:14.0
export ARCHS = arm64 arm64e
THEOS_PACKAGE_SCHEME = rootless

# INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = BoldersReborn

BoldersReborn_FILES = Tweak.xm Localization.m
BoldersReborn_CFLAGS = -fobjc-arc -Wno-vla-cxx-extension

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += boldersrebornprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
