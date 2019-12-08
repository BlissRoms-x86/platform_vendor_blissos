# Inherit common Bliss stuff
$(call inherit-product, vendor/blissos/config/common.mk)
$(call inherit-product, vendor/blissos/config/common_full.mk)
$(call inherit-product, vendor/blissos/config/BoardConfigBlissOS.mk)
$(call inherit-product, vendor/blissos/config/common_full_tablet_wifionly.mk)
$(call inherit-product, vendor/blissos/config/bliss_audio.mk)
$(call inherit-product, vendor/blissos/addon.mk)
include vendor/blissos/config/BoardConfigBlissOS.mk


# Boot animation
TARGET_SCREEN_HEIGHT := 1080
TARGET_SCREEN_WIDTH := 1080
TARGET_BOOTANIMATION_HALF_RES := true

# If using gms
ifeq ($(USE_GMS),true)
$(call inherit-product, vendor/gms/config.mk)
endif

# If using fdroid
ifeq ($(USE_FDROID),true)
$(call inherit-product-if-exists, vendor/foss/foss.mk)
# Get GMS
$(call inherit-product-if-exists,vendor/microg/microg.mk)
# FOSS apps
PRODUCT_PACKAGES += \
	FDroid \
	FDroidPrivilegedExtension \
	FakeStore \
	Phonesky \
	DroidGuard \
	GmsCore \
	privapp-permissions-com.google.android.gms.xml \
	GsfProxy \
	MozillaNlpBackend \
	NominatimNlpBackend \
	com.google.android.maps \
	com.google.android.maps.jar \
	com.google.android.maps.xml \
	OpenWeatherMapWeatherProvider \
	additional_repos.xml

endif

PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
	persist.sys.nativebridge=1 \
	ro.enable.native.bridge.exec=1

PRODUCT_PROPERTY_OVERRIDES += \
    ro.mot.deep.sleep.supported=true \
    persist.sys.nativebridge=1 \
	ro.enable.native.bridge.exec=1
    
# Required packages
PRODUCT_PACKAGES += \
    LatinIME

# Include Bliss x86 overlays
PRODUCT_PACKAGE_OVERLAYS += vendor/blissos/overlay/x86

PRODUCT_SHIPPING_API_LEVEL := 19

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.activities_on_secondary_displays.xml:system/etc/permissions/android.software.activities_on_secondary_displays.xml \
    frameworks/native/data/etc/android.software.midi.xml:system/etc/permissions/android.software.midi.xml \
    frameworks/native/data/etc/android.software.picture_in_picture.xml:system/etc/permissions/android.software.picture_in_picture.xml \
    frameworks/native/data/etc/android.software.print.xml:system/etc/permissions/android.software.print.xml \
    frameworks/native/data/etc/android.software.webview.xml:system/etc/permissions/android.software.webview.xml \
    frameworks/native/data/etc/android.hardware.gamepad.xml:system/etc/permissions/android.hardware.gamepad.xml \

# Enable MultiWindow
PRODUCT_PROPERTY_OVERRIDES += \
    persist.sys.debug.multi_window=true
    persist.sys.debug.desktop_mode=true

# Copy all Bliss-specific init rc files
$(foreach f,$(wildcard vendor/blissos/prebuilt/common/etc/init/*.rc),\
	$(eval PRODUCT_COPY_FILES += $(f):$(TARGET_COPY_OUT_SYSTEM)/etc/init/$(notdir $f)))

$(foreach f,$(wildcard vendor/blissos/prebuilt/common/bin/*),\
	$(eval PRODUCT_COPY_FILES += $(f):$(TARGET_COPY_OUT_SYSTEM)/bin/$(notdir $f)))

$(foreach f,$(wildcard vendor/blissos/prebuilt/common/media/alarms/*),\
	$(eval PRODUCT_COPY_FILES += $(f):$(TARGET_COPY_OUT_SYSTEM)/media/alarms/$(notdir $f)))

$(foreach f,$(wildcard vendor/blissos/prebuilt/common/media/notifications/*),\
	$(eval PRODUCT_COPY_FILES += $(f):$(TARGET_COPY_OUT_SYSTEM)/media/notifications/$(notdir $f)))

$(foreach f,$(wildcard vendor/blissos/prebuilt/common/media/ringtones/*),\
	$(eval PRODUCT_COPY_FILES += $(f):$(TARGET_COPY_OUT_SYSTEM)/media/ringtones/$(notdir $f)))

$(foreach f,$(wildcard vendor/blissos/prebuilt/common/alsa/*),\
	$(eval PRODUCT_COPY_FILES += $(f):$(TARGET_COPY_OUT_SYSTEM)/etc/alsa/$(notdir $f)))

$(foreach f,$(wildcard vendor/blissos/prebuilt/common/idc/*),\
	$(eval PRODUCT_COPY_FILES += $(f):$(TARGET_COPY_OUT_SYSTEM)/usr/idc/$(notdir $f)))

$(foreach f,$(wildcard vendor/blissos/prebuilt/common/keylayout/*),\
	$(eval PRODUCT_COPY_FILES += $(f):$(TARGET_COPY_OUT_SYSTEM)/usr/keylayout/$(notdir $f)))

# Houdini addons
ifeq ($(USE_HOUDINI),true)

# Get proprietary files if any exists
$(call inherit-product, vendor/google/chromeos-x86/target/native_bridge_arm_on_x86.mk)
$(call inherit-product, vendor/google/chromeos-x86/target/houdini.mk)

WITH_NATIVE_BRIDGE := true
# TARGET_CPU_ABI2 must be set to make soong build additional ARM code
# However, if no native bridge is bundled, the system does not support
# ARM binaries by default, yet it indicates support through
# ro.product.cpu.abi2 in build.prop.

# Attempt to reset ro.product.cpu.abi2 using
# https://github.com/LineageOS/android_build/commit/94282042cac8dc66e9935c8d7455bd323b0b6716
PRODUCT_BUILD_PROP_OVERRIDES += TARGET_CPU_ABI2=

PRODUCT_PROPERTY_OVERRIDES += \
    ro.dalvik.vm.isa.arm=x86 \
    ro.enable.native.bridge.exec=1 \
    ro.dalvik.vm.native.bridge=libhoudini.so

endif

# Widevine addons
ifeq ($(USE_WIDEVINE),true)

# Get proprietary files if any exists
$(call inherit-product, vendor/google/chromeos-x86/target/widevine.mk)

endif

# Optional packages
PRODUCT_PACKAGES += \
    LiveWallpapersPicker \
    PhotoTable \
    Terminal

# Custom Lineage packages
PRODUCT_PACKAGES += \
    htop \
    nano 

# Set Bliss Desktop Mode by default
# Use 'export BLISS_DESKTOPMODE=true' or set 
# 'BLISS_DESKTOPMODE := true' within BoardConfig.mk. 
ifeq ($(BLISS_DESKTOPMODE),true)

# Remove packages
PRODUCT_PACKAGES -= \
    Eleven \
    Jelly \
    Launcher3 \

endif


# Exchange support
PRODUCT_PACKAGES += \
    Exchange2 \

# Boot Animation
# PRODUCT_PACKAGES += \
#     bootanimation.zip

PRODUCT_COPY_FILES += \
    vendor/blissos/bootanimation/bootanimation.zip:system/media/bootanimation.zip
    
