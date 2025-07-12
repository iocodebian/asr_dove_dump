#!/system/bin/sh

#
# Copyright (C) 2023 ASR Micro Limited
# All Rights Reserved.
#

WIFI_POWER_STATUS=/sys/devices/platform/asr5803-power/wifipower
BT_POWER_STATUS=/sys/devices/platform/asr5803-power/btpower
HWRESET_NODE=/sys/devices/platform/asr5803-power/hwreset
WLAN_RESET_MODE=/sys/devices/platform/asr5803-power/wlan_reset_mode
WLAN_WORK_MODE=/sys/devices/platform/asr5803-power/wlan_work_mode

rmmod /vendor/lib/modules/asr5803.ko

