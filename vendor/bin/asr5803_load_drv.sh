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

WLAN_POWER_CONFIG_FILE=/vendor/etc/wifi/wlan_power_control.conf

SAVE_LOG_TO_FILE="0"
LOG_FILE="/sdcard/asrlog/asr5803_load_drv.log"

wlan_insmod_args=()

function print_log()
{
	if [ $SAVE_LOG_TO_FILE == "1" ]; then
		echo $(date +%Y-%m-%d' '%H:%M:%S.%6N) $1 >> $LOG_FILE
	else
		echo $(date +%Y-%m-%d' '%H:%M:%S.%6N) $1
	fi
}

function get_args_from_file()
{
	wlan_power_args_file=$1

	while read line
	do
		if [ ! -z "$(echo $line | grep "^#")" ]; then
			continue
		fi
		wlan_insmod_args=(${wlan_insmod_args[@]} $line)
	done < $1
}

function check_wlan_file()
{
	config_file=$1
	check_str1="TxPowerControlMode"
	check_str2="PS_mode"

	if [ ! -f "$config_file" ]; then
		return 0
	fi

	get_args_from_file $config_file

	len=${#wlan_insmod_args[@]}
	input_check1=${wlan_insmod_args[0]: 0: 18}
	input_check2=${wlan_insmod_args[$((len-1))]: 0: 7}

	if [ $input_check1 = $check_str1 ] && [ $input_check2 = $check_str2 ]; then
		# file ok
		return 1
	else
		# file invalid
		return 0
	fi
}

function install_wlan_asr5803_driver()
{
	echo 1 > $WIFI_POWER_STATUS

	check_wlan_file $WLAN_POWER_CONFIG_FILE
	ret=$?
	print_log "ret=$ret"
	if [ $ret == "0" ]; then
		insmod /vendor/lib/modules/asr5803.ko invalid_param=1
	fi
	if [ $ret == "1" ]; then
		log -t asr5803_load_drv insmod /vendor/lib/modules/asr5803.ko param_type=0 ${wlan_insmod_args[@]}
		insmod /vendor/lib/modules/asr5803.ko param_type=0 ${wlan_insmod_args[@]}
	fi
}

function main()
{
	install_wlan_asr5803_driver
}
main
