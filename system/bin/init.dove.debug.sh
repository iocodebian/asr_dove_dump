#! /system/bin/sh
#
# Copyright (C) 2023 ASR Micro Limited
# All Rights Reserved.
#
monkey --pkg-whitelist-file /system/etc/whitelist.txt --throttle 600 --pct-touch 35 --pct-motion 30 --ignore-native-crashes --ignore-crashes --ignore-timeouts --ignore-security-exceptions -v -v -v 6000000
