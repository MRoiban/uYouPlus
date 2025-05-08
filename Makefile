# 1. Global build variables
export TARGET          = iphone:clang:latest:15.0        # use 'latest' or replace with '17.4' for your SDK :contentReference[oaicite:0]{index=0}
export SDK_PATH        = $(THEOS)/sdks/iPhoneOS17.4.sdk  # point to the patched iOS 17.4 SDK :contentReference[oaicite:1]{index=1}
export SYSROOT         = $(SDK_PATH)                     # ensure headers/libs resolve correctly :contentReference[oaicite:2]{index=2}
export ARCHS           = arm64                           # modern devices only :contentReference[oaicite:3]{index=3}

# 2. Tweak instance configuration
TWEAK_NAME             = uYouPlus
PACKAGE_NAME           = $(TWEAK_NAME)
PACKAGE_VERSION        = $(YOUTUBE_VERSION)-$(UYOU_VERSION)

# 3. Source files
$(TWEAK_NAME)_FILES    := $(wildcard Sources/*.xm) $(wildcard Sources/*.x)  # logos & ObjC sources :contentReference[oaicite:4]{index=4}

# 4. Only include your selected subprojects
SUBPROJECTS            += Tweaks/YouQuality \
                          Tweaks/YTVideoOverlay \
                          Tweaks/YouTubeHeader \
                          Tweaks/iSponsorBlock \
                          Tweaks/YTClassicVideoQuality \
                          Tweaks/PSHeader             # minimal set :contentReference[oaicite:5]{index=5}
include $(THEOS_MAKE_PATH)/aggregate.mk

# 5. Dylibs to inject (only your six tweaks)
$(TWEAK_NAME)_INJECT_DYLIBS := \
  $(THEOS_OBJ_DIR)/YouQuality.dylib \
  $(THEOS_OBJ_DIR)/YTVideoOverlay.dylib \
  $(THEOS_OBJ_DIR)/YouTubeHeader.dylib \
  $(THEOS_OBJ_DIR)/iSponsorBlock.dylib \
  $(THEOS_OBJ_DIR)/YTClassicVideoQuality.dylib \
  $(THEOS_OBJ_DIR)/PSHeader.dylib          # trim to kept tweaks :contentReference[oaicite:6]{index=6}

# 6. No extra embedded libraries or frameworks
$(TWEAK_NAME)_EMBED_LIBRARIES  :=
$(TWEAK_NAME)_EMBED_FRAMEWORKS :=
$(TWEAK_NAME)_EMBED_BUNDLES    :=
$(TWEAK_NAME)_EMBED_EXTENSIONS :=

# 7. Link against standard frameworks only
$(TWEAK_NAME)_FRAMEWORKS = UIKit Security

# 8. Compile flags
$(TWEAK_NAME)_CFLAGS     = -fobjc-arc -DTWEAK_VERSION=\"$(PACKAGE_VERSION)\" \
                           -Wno-module-import-in-extern-c

# 9. Packaging & signing
INSTALL_TARGET_PROCESSES = YouTube
REMOVE_EXTENSIONS        = 1
CODESIGN_IPA             = 0

# 10. Build rules
include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk                   # load default tweak build rules :contentReference[oaicite:7]{index=7}
