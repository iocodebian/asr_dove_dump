#!/vendor/bin/sh
LOG_DIR=/sdcard/asrlog/
LOG_FILE="$LOG_DIR/wifi_test.log"
MMC_NAME=""
function pr_log()
{
	echo $1 >> $LOG_FILE
}

function get_mmc_name()
{
	for dir in $(ls /sys/devices/platform/soc/d4200000.axi/d4280800.sdh/mmc_host/)
	do
		MMC_NAME=$dir
		pr_log "${MMC_NAME}"
	done 
}

function main()
{
	#Check the existent log directory
	if [ ! -d $LOG_DIR ]; then
		echo "mkdir $LOG_DIR"
		mkdir $LOG_DIR
	fi
	#Parse arguments
	cmd_type=`getprop vendor.sys.wifi.cmdtype`
	get_mmc_name
	#Specific nvocations
	cmd_content=`getprop vendor.sys.wifi.cmdcontent`
	pr_log "EEM_OPS_CMD: $cmd_content"
	pr_log $cmd_type
	pr_log $cmd_content
	case "$cmd_type" in
		"cali_tx")
		        pr_log "cali_tx cmd"
		        pr_log $cmd_content
			echo $cmd_content > /sys/devices/platform/soc/d4200000.axi/d4280800.sdh/mmc_host/${MMC_NAME}/${MMC_NAME}:0001/${MMC_NAME}:0001:1/cali_tx
		;;
		"cali_rx")
		        pr_log "cali_rx cmd"
		        pr_log $cmd_content
			echo $cmd_content > /sys/devices/platform/soc/d4200000.axi/d4280800.sdh/mmc_host/${MMC_NAME}/${MMC_NAME}:0001/${MMC_NAME}:0001:1/cali_rx
		;;
		*)
			echo "unknown command: [$ops_cmd] and arguments:[${param_array[@]}]"
		;;
	esac
}
main
