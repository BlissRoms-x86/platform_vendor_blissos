include vendor/blissos/config/BoardConfigKernel.mk

ifeq ($(BOARD_USES_QCOM_HARDWARE),true)
include vendor/blissos/config/BoardConfigQcom.mk
endif

include vendor/blissos/config/BoardConfigSoong.mk
