GO_EASY_ON_ME = 1
ARCHS = armv7 arm64
SDKVERSION = 7.0

include theos/makefiles/common.mk

TWEAK_NAME = BuddyLock
BuddyLock_FILES = Tweak.xm

include $(THEOS_MAKE_PATH)/tweak.mk
