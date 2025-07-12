#!/vendor/bin/sh
LOG_DIR=/sdcard/asrlog/
LOG_FILE="$LOG_DIR/eem_ops.log"
uport="1"
param_array=
function pr_log()
{
	echo $1 >> $LOG_FILE
}

function reboot_calibration_test_entry()
{
	pr_log "reboot calibration"
	reboot calibration
}

function bt_start_test_entry()
{
	pr_log "bt start"
	bt_prepare 3000000 $uport ctsrts /vendor/firmware/bt/btlst_dissleep.bin /vendor/firmware/bt/build_ram_only.bin 1
}

function ble_start_test_entry()
{
	pr_log "ble start"
	bt_prepare 3000000 $uport ctsrts /vendor/firmware/bt/btlst_dissleep.bin /vendor/firmware/bt/build_ram_only.bin 2
}

function main()
{
	#Check the existent log directory
	if [ ! -d $LOG_DIR ]; then
		echo "mkdir $LOG_DIR"
		mkdir $LOG_DIR
	fi

	PRODUCT_NAME=`getprop ro.product.product.name`
	if [[ $PRODUCT_NAME == "dove_evb_z1" ]];then
		uport="2"
	fi
	pr_log "PRODUCT_NAME: $PRODUCT_NAME, UART port: $uport"

	#Parse arguments
	epar=`getprop vendor.sys.eem.ops.param`
	pr_log "EEM_OPS_PARAM: $epar"
	param_array=(${epar//,/ })
	#Specific nvocations
	ops_cmd=`getprop vendor.sys.eem.ops.cmd`
	pr_log "EEM_OPS_CMD: $ops_cmd"
	case "$ops_cmd" in
		"reboot_calibration")
			reboot_calibration_test_entry
		;;
		"bt_start")
			bt_start_test_entry
		;;
		"ble_start")
			ble_start_test_entry
		;;
		*)
			echo "unknown command: [$ops_cmd] and arguments:[${param_array[@]}]"
		;;
	esac
}
main
