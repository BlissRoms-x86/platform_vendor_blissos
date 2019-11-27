# Inherit full common Bliss stuff
$(call inherit-product, vendor/blissos/config/common_full.mk)

# Required packages
PRODUCT_PACKAGES += \
    LatinIME

# Include Lineage LatinIME dictionaries
PRODUCT_PACKAGE_OVERLAYS += vendor/blissos/overlay/dictionaries

$(call inherit-product, vendor/blissos/config/telephony.mk)
