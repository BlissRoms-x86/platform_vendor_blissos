# Inherit common Bliss stuff
$(call inherit-product, vendor/blissos/config/common.mk)

PRODUCT_SIZE := full

# Recorder
PRODUCT_PACKAGES += \
    Recorder
