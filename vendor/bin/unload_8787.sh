#!/system/bin/sh

stop mfgbridge
ifconfig mlan0 down
hciconfig hci0 down
rmmod mbt8777
rmmod sd8777
rmmod mlan777

