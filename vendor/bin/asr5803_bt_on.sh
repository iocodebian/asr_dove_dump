#!/system/bin/sh

ASR5803_BT_RFKILL=/sys/devices/platform/asr-bluetooth/rfkill/rfkill0/state
ASR5803_BT_POWER=/sys/devices/platform/asr5803-power/btpower

function main()
{
   echo 1 > $(ASR5803_BT_POWER);
   sleep 1;
   echo 0 > $(ASR5803_BT_RFKILL);
   sleep 1;
   echo 1 > $(ASR5803_BT_RFKILL);
   sleep 1;
}
main
