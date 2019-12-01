my_path := $(call my-dir)

LOCAL_PATH := $(my_path)
include $(CLEAR_VARS)

# Copy files

define addon-copy-to-system
$(shell python "vendor/blissos/copy_files.py" "vendor/google/chromeos-x86/proprietary/$(1)/" "$(2)" "$(PLATFORM_SDK_VERSION)")
endef

# Houdini addons
ifeq ($(USE_HOUDINI),true)
PRODUCT_COPY_FILES += $(call addon-copy-to-system,houdini,bin) \

PRODUCT_COPY_FILES += $(call addon-copy-to-system,houdini,lib) \

PRODUCT_COPY_FILES += $(call addon-copy-to-system,houdini,etc) \

endif

# Widevine addons
ifeq ($(USE_WIDEVINE),true)

PRODUCT_COPY_FILES += $(call addon-copy-to-system,widevine,vendor/bin) \

PRODUCT_COPY_FILES += $(call addon-copy-to-system,widevine,vendor/lib) \

PRODUCT_COPY_FILES += $(call addon-copy-to-system,widevine,vendor/etc) \

endif
