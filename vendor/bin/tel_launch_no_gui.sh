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

setprop sys.telephony.default.loglevel 8
chown system:root /sys/class/power_supply/battery/capacity
chmod 0664 /sys/class/power_supply/battery/capacity

MODULE_DIR=/lib/modules
insmod $MODULE_DIR/msocketk.ko
insmod $MODULE_DIR/cploaddev.ko
#echo 1 > /sys/devices/system/cpu/cpu0/cp
insmod $MODULE_DIR/seh.ko

#This pcm_master argument have to set before cploader startup
pcm_master=`getprop persist.radio.pcmmaster`
if [ "$pcm_master" != "0" ]
then
	pcm_master="1"
fi
echo $pcm_master > /sys/module/audiostub/parameters/pcm_master

ssipc_enable=`getprop ro.cmd.ssipc_enable`
multisim=`getprop persist.radio.multisim.config`
#Below slice will set ssipc channels property and run channels.
if [ "$ssipc_enable" = "true" ]; then
	if [ "$multisim" = "dsds" ]; then
		echo 1 > sys/devices/virtual/ssipc_misc/umts_boot0/ssipc_dsds
	fi
	echo 1 > sys/devices/virtual/ssipc_misc/umts_boot0/ssipc_ch_enable
fi

# load cp and mrd image and release cp
/system/bin/cploader

ret="$?"
case "$ret" in
	    "-1")
		rmmod seh
		rmmod cploaddev
		rmmod msocketk
		exit
       ;;
	    "1")
		rmmod seh
		rmmod cploaddev
		rmmod msocketk
		start nvm-aponly
		start diag-aponly
		insmod $MODULE_DIR/citty.ko
		start atcmdsrv-aponly
		exit
       ;;
       *)
       ;;
esac

insmod $MODULE_DIR/usimeventk.ko
insmod $MODULE_DIR/citty.ko
insmod $MODULE_DIR/cci_datastub.ko
insmod $MODULE_DIR/ccinetdev.ko
insmod $MODULE_DIR/gs_modem.ko
insmod $MODULE_DIR/cidatattydev.ko
insmod $MODULE_DIR/audiostub.ko pcm_master=$pcm_master

setprop sys.tools.enable 1

sync

/system/bin/eeh -M yes &
/system/bin/nvm &
/system/bin/diag &
if [ "$ssipc_enable" != "true" ]; then
	/system/bin/atcmdsrv &
else
	/system/bin/at_router &
fi
