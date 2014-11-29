include theos/makefiles/common.mk
export ARCHS = armv7 armv7s arm64
export SDKVERSION = 7.1
TWEAK_NAME = SprintTimer
SprintTimer_FILES = Tweak.xm
SprintTimer_FRAMEWORKS = Foundation UIKit CoreGraphics CoreImage QuartzCore CoreMotion
include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 MobileTimer"
<<<<<<< HEAD
SUBPROJECTS += sprinttimerprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
=======
>>>>>>> 38d529f5cc238a3092714f3fe86711e89f31fce3
