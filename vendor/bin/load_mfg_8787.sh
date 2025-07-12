#!/system/bin/sh

rmmod mbt8777
rmmod sd8777
rmmod mlan8777

echo 0 > /sys/devices/platform/sd8x-rfkill/pwr_ctrl
echo 1 > /sys/devices/platform/sd8x-rfkill/pwr_ctrl

insmod /lib/modules/mlan8777.ko
insmod /lib/modules/sd8777.ko "mfg_mode=1 drv_mode=1 dts_enable=0 fw_name=mrvl/sd8787_Ax.bin"

insmod /lib/modules/mbt8777.ko "multi_fn=4"

start mfgbridge
