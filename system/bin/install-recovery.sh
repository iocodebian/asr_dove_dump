#!/system/bin/sh
if ! applypatch -c EMMC:/dev/block/bootdevice/by-name/recovery:26663200:f66a90729b9083d7bf9b57b04afccc7fe97b5bef; then
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/bootdevice/by-name/boot:22096160:bfeef46cc0919f4275d81cbd96cdc1fab4d4eab7 EMMC:/dev/block/bootdevice/by-name/recovery f66a90729b9083d7bf9b57b04afccc7fe97b5bef 26663200 bfeef46cc0919f4275d81cbd96cdc1fab4d4eab7:/system/recovery-from-boot.p && log -t recovery "Installing new recovery image: succeeded" || log -t recovery "Installing new recovery image: failed"
else
  log -t recovery "Recovery image already installed"
fi
