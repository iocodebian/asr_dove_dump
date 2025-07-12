#! /vendor/bin/sh

#
# Copyright (C) 2023 ASR Micro Limited
# All Rights Reserved.
#

if [ -f /sys/class/drm/card0-DSI-1/modes ]; then
    echo "detect" > /sys/class/drm/card0-DSI-1/status
    mode_file=/sys/class/drm/card0-DSI-1/modes
    while read line; do
        fb_width=${line%%x*};
        break;
    done < $mode_file
fi

log -t BOOT -p i "configure vendor.display.lcd_density based on fb width: '$fb_width'"

function set_density_by_fb() {
    #put default density based on width
    if [ -z $fb_width ]; then
        setprop vendor.display.lcd_density 320
    else
        if [ $fb_width -ge 720 ]; then
           setprop vendor.display.lcd_density 320
        elif [ $fb_width -ge 320 ]; then
            setprop vendor.display.lcd_density 160 #for 320X386 resolution
        elif [ $fb_width -ge 240 ]; then
            setprop vendor.display.lcd_density 120 #for 240X240 resolution
        else
            setprop vendor.display.lcd_density 160
        fi
    fi
}

set_density_by_fb
