export SYSROOT = $(THEOS)/sdks/iPhoneOS14.4.sdk/
export TARGET := iphone:clang:latest:14.0
export ARCHS = arm64 arm64e

export FINAL = 0
# DEBUG = 0

INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = BoldersReborn

$(TWEAK_NAME)_FILES = Tweak.xm
$(TWEAK_NAME)_CFLAGS = -fobjc-arc

ifeq ($(THEOS_PACKAGE_SCHEME), rootless)
$(TWEAK_NAME)_CFLAGS = -fobjc-arc -DTHEOS_PACKAGE_SCHEME=rootless
endif

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += boldersrebornprefs
include $(THEOS_MAKE_PATH)/aggregate.mk