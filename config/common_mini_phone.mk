# Inherit mini common Bliss stuff
$(call inherit-product, vendor/blissos/config/common_mini.mk)

# Required packages
PRODUCT_PACKAGES += \
    LatinIME

$(call inherit-product, vendor/blissos/config/telephony.mk)
