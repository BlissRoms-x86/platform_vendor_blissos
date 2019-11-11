# Versioning System For Bliss
# Bliss RELEASE VERSION
BLISS_VERSION_MAJOR = 12
BLISS_VERSION_MINOR = 1
BLISS_VERSION_MAINTENANCE = Stable

#ifdef BLISS_VERSION_MAINTENANCE
#    VERSION := $(BLISS_VERSION_MAJOR).$(BLISS_VERSION_MINOR)-$(BLISS_VERSION_MAINTENANCE)
#else
    VERSION := $(BLISS_VERSION_MAJOR).$(BLISS_VERSION_MINOR)
#endif

TARGET_PRODUCT_SHORT := $(subst bliss_,,$(BLISS_BUILDTYPE))

# Set BLISS_BUILDTYPE
ifdef BLISS_NIGHTLY
    BLISS_BUILDTYPE := NIGHTLY
endif
ifdef BLISS_EXPERIMENTAL
    BLISS_BUILDTYPE := EXPERIMENTAL
endif
#ifdef BLISS_MAINTENANCE
#    BLISS_BUILDTYPE := MAINTENANCE
#endif
# Set Unofficial if no buildtype set (Buildtype should ONLY be set by BLISS Devs!)
ifdef BLISS_BUILDTYPE
else
    BLISS_BUILDTYPE := UNOFFICIAL
endif

# Set BLISS version
ifdef BLISS_RELEASE
    BLISS_VERSION := Bliss-v$(VERSION)
else
    BLISS_VERSION := Bliss-v$(VERSION)-$(BLISS_BUILD)-$(BLISS_BUILDTYPE)-$(shell date +%Y%m%d)
endif

BLISS_DISPLAY_VERSION := $(VERSION)
BLISS_DISPLAY_BUILDTYPE := $(BLISS_BUILDTYPE)
BLISS_FINGERPRINT := Bliss/$(VERSION)/$(TARGET_PRODUCT_SHORT)/$(shell date +%Y%m%d)

PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
  ro.bliss.version=$(BLISS_DISPLAY_VERSION) \
  ro.bliss.build.status=$(BLISS_BUILDTYPE) \
  ro.bliss.releasetype=$(BLISS_BUILDTYPE) \
  ro.bliss.changelog.version=Changelog-$(BLISS_VERSION) \
  ro.bliss.fingerprint=$(BLISS_FINGERPRINT)
