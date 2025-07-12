#!/vendor/bin/sh
LOG_DIR=/sdcard/asrlog/
LOG_FILE="$LOG_DIR/eem_stop.log"
function pr_log()
{
	echo $1 >> $LOG_FILE
}

function ble_test_stop_entry()
{
	pr_log "ble...... stop"
	pkill -9 bt_prepare
	echo 0 > /sys/devices/platform/asr-bluetooth/rfkill/rfkill0/state
}

function bt_test_stop_entry()
{
	pr_log "bt...... stop"
	echo 0 > /sys/devices/platform/asr-bluetooth/rfkill/rfkill0/state
}

function main()
{
	#Check the existent log directory
	if [ ! -d $LOG_DIR ]; then
		echo "mkdir $LOG_DIR"
		mkdir $LOG_DIR
	fi
	#Specific nvocations
	ops_stop=`getprop vendor.sys.eem.ops.stop`
	pr_log "EEM_OPS_CMD: $ops_stop"
	case "$ops_stop" in
		"ble_stop")
			ble_test_stop_entry
		;;
		"bt_stop")
			bt_test_stop_entry
		;;
		*)
			echo "unknown command: [$ops_stop]"
		;;
	esac
}
main
