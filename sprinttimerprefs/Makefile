include theos/makefiles/common.mk
ARCHS = armv7 armv7s arm64
SDKVERSION = 7.1

BUNDLE_NAME = sprinttimerprefs
sprinttimerprefs_FILES = sprinttimerprefs.mm
sprinttimerprefs_INSTALL_PATH = /Library/PreferenceBundles
sprinttimerprefs_FRAMEWORKS = Foundation UIKit CoreGraphics CoreImage QuartzCore Social
sprinttimerprefs_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/sprinttimerprefs.plist$(ECHO_END)
