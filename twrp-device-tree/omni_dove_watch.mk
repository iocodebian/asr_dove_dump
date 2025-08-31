#
# Copyright (C) 2025 The Android Open Source Project
# Copyright (C) 2025 SebaUbuntu's TWRP device tree generator
#
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Inherit some common Omni stuff.
$(call inherit-product, vendor/omni/config/common.mk)

# Inherit from dove_watch device
$(call inherit-product, device/asr/dove_watch/device.mk)

PRODUCT_DEVICE := dove_watch
PRODUCT_NAME := omni_dove_watch
PRODUCT_BRAND := ASR
PRODUCT_MODEL := A1 mini
PRODUCT_MANUFACTURER := asr

PRODUCT_GMS_CLIENTID_BASE := android-asr

PRODUCT_BUILD_PROP_OVERRIDES += \
    PRIVATE_BUILD_DESC="dove_watch-user 8.1.0 ORWT.032.01.240530 eng.lichan.20240619.110334 release-keys"

BUILD_FINGERPRINT := ASR/dove_watch/dove_watch:8.1.0/ORWT.032.01.240530/lichan06191103:user/release-keys
