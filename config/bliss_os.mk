# Inherit common Bliss stuff
$(call inherit-product,vendor/blissos/config/common.mk)
$(call inherit-product,vendor/blissos/config/common_full.mk)
$(call inherit-product,vendor/blissos/config/BoardConfigBlissOS.mk)
$(call inherit-product,vendor/blissos/config/common_full_tablet_wifionly.mk)
$(call inherit-product,vendor/blissos/config/bliss_audio.mk)
# $(call inherit-product-if-exists,vendor/blissos/addon.mk)

# Get proprietary files if any exists
# $(call inherit-product,vendor/google/chromeos-x86/target/native_bridge_arm_on_x86.mk)
# $(call inherit-product,vendor/google/chromeos-x86/target/houdini.mk)
# $(call inherit-product,vendor/google/chromeos-x86/target/widevine.mk)

# Boot animation
TARGET_SCREEN_HEIGHT := 1080
TARGET_SCREEN_WIDTH := 1080
TARGET_BOOTANIMATION_HALF_RES := true

ifeq ($(USE_FDROID),true)
$(call inherit-product,vendor/fdroid/config.mk)
endif

ifeq ($(USE_FOSS),true)
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

# Required packages
PRODUCT_PACKAGES += \
    LatinIME

# Include Bliss x86 overlays
PRODUCT_PACKAGE_OVERLAYS += vendor/blissos/overlay/x86

# PRODUCT_PROPERTY_OVERRIDES += \
    ro.mot.deep.sleep.supported=true

PRODUCT_SHIPPING_API_LEVEL := 19

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.activities_on_secondary_displays.xml:system/etc/permissions/android.software.activities_on_secondary_displays.xml \
    frameworks/native/data/etc/android.software.midi.xml:system/etc/permissions/android.software.midi.xml \
    frameworks/native/data/etc/android.software.picture_in_picture.xml:system/etc/permissions/android.software.picture_in_picture.xml \
    frameworks/native/data/etc/android.software.print.xml:system/etc/permissions/android.software.print.xml \
    frameworks/native/data/etc/android.software.webview.xml:system/etc/permissions/android.software.webview.xml \
    frameworks/native/data/etc/android.hardware.gamepad.xml:system/etc/permissions/android.hardware.gamepad.xml \
    $(foreach f,$(wildcard $(LOCAL_PATH)/prebuilt/common/alsa/*),$(f):$(subst $(LOCAL_PATH),system/etc,$(f))) \
    $(foreach f,$(wildcard $(LOCAL_PATH)/prebuilt/common/idc/*.idc $(LOCAL_PATH)/prebuilt/common/keylayout/*.kl),$(f):$(subst $(LOCAL_PATH),system/usr,$(f)))

# Enable MultiWindow
PRODUCT_PROPERTY_OVERRIDES += \
    persist.sys.debug.multi_window=true
    persist.sys.debug.desktop_mode=true

# Copy all Bliss-specific init rc files
$(foreach f,$(wildcard vendor/blissos/prebuilt/common/etc/init/*.rc),\
$(eval PRODUCT_COPY_FILES += $(f):system/etc/init/$(notdir $f)))

$(foreach f,$(wildcard vendor/blissos/prebuilt/common/bin/*),\
$(eval PRODUCT_COPY_FILES += $(f):system/bin/$(notdir $f)))

# Optional packages
PRODUCT_PACKAGES += \
    LiveWallpapersPicker \
    PhotoTable \
    Terminal
    
# Custom Lineage packages
PRODUCT_PACKAGES += \
    Eleven \
    Jelly \
    htop \
    nano 

# Exchange support
PRODUCT_PACKAGES += \
    Exchange2
