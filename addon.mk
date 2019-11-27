my_path := $(call my-dir)

LOCAL_PATH := $(my_path)
include $(CLEAR_VARS)

# Copy files

define addon-copy-to-system
$(shell python "vendor/x86/copy_files.py" "vendor/x86/$(1)/" "$(2)" "$(PLATFORM_SDK_VERSION)")
endef


PRODUCT_COPY_FILES += $(call addon-copy-to-system,system,bin) \

PRODUCT_COPY_FILES += $(call addon-copy-to-system,system,lib) \
