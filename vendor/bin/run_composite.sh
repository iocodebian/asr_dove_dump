#!/system/bin/sh

function copy_if_not_exist()
{
if [ -f "${2}" ]; then
		echo "existing ${2}";
else
	if [ -f "${1}" ]; then
		cp ${1} ${2}
		chmod 664 ${2}
		chown system.system ${2}
		echo "cp: ${1} -> ${2}"
	fi
fi
}
band_id=`getprop ro.boot.band_id`
if [ "$band_id" -eq 1 ]
then
		rfcfg_src1="TTPCom_NRAM2_ABMM_WRITEABLE_DATA_b38.gki"
		rfcfg_src2="TTPCom_NRAM2_ABMM_WRITEABLE_DATA_2_b38.gki"
else
		rfcfg_src1="TTPCom_NRAM2_ABMM_WRITEABLE_DATA_b41.gki"
		rfcfg_src2="TTPCom_NRAM2_ABMM_WRITEABLE_DATA_2_b41.gki"
fi

rfcfg_dst1="TTPCom_NRAM2_ABMM_WRITEABLE_DATA.gki"
rfcfg_dst2="TTPCom_NRAM2_ABMM_WRITEABLE_DATA_2.gki"
copy_if_not_exist "/etc/tel/nvm/${rfcfg_src1}" "${NVM_ROOT_DIR}/${rfcfg_dst1}"
copy_if_not_exist "/etc/tel/nvm/${rfcfg_src2}" "${NVM_ROOT_DIR}/${rfcfg_dst2}"

pactrl_src="PA_Ctrl_Table.nvm"
copy_if_not_exist "/etc/tel/nvm/${pactrl_src}" "${NVM_ROOT_DIR}/${pactrl_src}"
msa_cfg_src="Msa_Cfg.nvm"
copy_if_not_exist "/etc/tel/nvm/${msa_cfg_src}" "${NVM_ROOT_DIR}/${msa_cfg_src}"

#chown system:root /sys/class/power_supply/battery/capacity
#chmod 0664 /sys/class/power_supply/battery/capacity

#MODULE_DIR=/lib/modules
#insmod $MODULE_DIR/msocketk.ko
#insmod $MODULE_DIR/cploaddev.ko
#insmod $MODULE_DIR/seh.ko
#insmod $MODULE_DIR/iml_module.ko
#insmod $MODULE_DIR/m3rmdev.ko

#This pcm_master argument have to set before cploader startup
#pcm_master=`getprop persist.radio.pcmmaster`
#if [ "$pcm_master" != "0" ]
#then
#	pcm_master="1"
#fi
#echo $pcm_master > /sys/module/audiostub/parameters/pcm_master

#ssipc_enable=`getprop ro.cmd.ssipc_enable`
#multisim=`getprop persist.radio.multisim.config`
##Below slice will set ssipc channels property and run channels.
#if [ "$ssipc_enable" = "true" ]; then
#	if [ "$multisim" = "dsds" ]; then
#		echo 1 > sys/devices/virtual/ssipc_misc/umts_boot0/ssipc_dsds
#	fi
#	echo 1 > sys/devices/virtual/ssipc_misc/umts_boot0/ssipc_ch_enable
#fi

#qemu.hw.mainkeys will be set in device.mk
#enable mainkey in navigation bar
#sensor_id=`cat /sys/bus/i2c/devices/1-005d/sensor_id`
#if [ "$sensor_id" = "GT9157 sensorID is 2" ]; then
#	setprop qemu.hw.mainkeys 0
#fi


# load cp and mrd image and release cp
/vendor/bin/mrdloader /data/NVM
ret="$?"
echo "mrdloader result : $ret" > /dev/kmsg
/vendor/bin/cploader

ret="$?"
echo "cploader result : $ret" > /dev/kmsg

if [ ! -e $MARVELL_RW_DIR ]; then
	mkdir -p $MARVELL_RW_DIR
	chown system.system $MARVELL_RW_DIR
	chmod 0755 $MARVELL_RW_DIR
fi

#case "$ret" in
#	    "255")
#		rmmod seh
#		rmmod cploaddev
#		rmmod msocketk
#		stop ril-daemon
#		exit
#      ;;
#	    "1")
#		rmmod seh
#		rmmod cploaddev
#		rmmod msocketk
#		stop ril-daemon
#		start nvm-aponly
#		start diag-aponly
#		insmod $MODULE_DIR/citty.ko
#		start atcmdsrv-aponly
#		exit
#       ;;
#       *)
#       ;;
#esac

#insmod $MODULE_DIR/usimeventk.ko
#insmod $MODULE_DIR/citty.ko
#insmod $MODULE_DIR/cci_datastub.ko
#insmod $MODULE_DIR/ccinetdev.ko
#insmod $MODULE_DIR/gs_modem.ko
#insmod $MODULE_DIR/cidatattydev.ko
#insmod $MODULE_DIR/audiostub.ko pcm_master=$pcm_master

sync

cp_standalone=`getprop persist.radio.cp.standalone`
if [ "$cp_standalone" = "true" ];
then
    start nvm
    start diag-aponly
    start seh_dumper
else
    start eeh
    start nvm
    start diag
    start iml
fi
start atcmdsrv

#if [ "$ssipc_enable" != "true" ]; then
#	testMode=`getprop persist.sys.telephony.testmode`
#	l1mod="L1V"
#	if [ "${testMode/$l1mod}" = "$testMode" ];
#	then
#		#original str was not changed by subtraction, L1V test mode not set
#		start atcmdsrv
#	else
#		start atcmdsrv-aponly
#	fi
#else
#	start at_router
#fi

start imsc
#start imsc2
