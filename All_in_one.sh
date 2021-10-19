#!/bin/bash

Stock_flash(){
echo -e "\nStarting the Stock Firmware Flash module, please make sure your device is in the bootloader"
printf "This will take about 2 minutes"

fastboot getvar max-sparse-size
fastboot oem fb_mode_set
fastboot flash partition gpt.bin
fastboot flash bootloader bootloader.img
fastboot flash modem NON-HLOS.bin
fastboot flash fsg fsg.mbn
fastboot erase modemst1
fastboot erase modemst2
fastboot flash dsp adspso.bin
fastboot flash logo logo.bin
fastboot flash boot boot.img
fastboot flash recovery recovery.img
fastboot flash system system.img_sparsechunk.0
fastboot flash system system.img_sparsechunk.1
fastboot flash system system.img_sparsechunk.2
fastboot flash system system.img_sparsechunk.3
fastboot flash system system.img_sparsechunk.4
fastboot flash system system.img_sparsechunk.5
fastboot flash system system.img_sparsechunk.6
fastboot flash system system.img_sparsechunk.7
fastboot flash system system.img_sparsechunk.8
fastboot flash oem oem.img
fastboot erase cache
fastboot erase userdata
fastboot erase DDR
fastboot oem fb_mode_clear
fastboot reboot bootloader
 
printf "Flashing Complete"
}


Check_Return() {
  #check previous command result , 0 = ok ,  non-0 = something wrong.
# shellcheck disable=SC2181
if [[ $? != "0" ]]; then
  if [[ -n "$1" ]] ; then
    echo -e "\n\n\n$1"
  fi
  echo -e  "above command failed..."
  Debug_Log2 "command failed, exiting. Looser. For more information read /var/log/installLogs.txt [404]"
  if [[ "$2" = "no_exit" ]] ; then
    echo -e"\nRetrying... Cross your fingers"
  else
    exit
  fi
fi
}

Debug_Log() {
echo -e "\n${1}=${2}\n" >> /tmp/MotoScript.log
}



Interactive_Mode() {
echo -e "	GS Connect | MotoScript 
1. Stock Firmware Flash.
2. TWRP Custom Recovery Install.
3. Rooting your device.
4. Exit.
"
read -r -p "  Please enter the number[1-4]: " Input_Number
echo ""
case "$Input_Number" in
  1)
  Stock_flash
  ;;
  2)
  TWRP_install
  ;;
  3)
  Root_device
  ;;
  4)
  exit
  ;;
  *)
  echo -e " You scared ninja? JK come back whenever you wish \n"
  exit
  ;;
esac
}
TWRP_install(){
fastboot flash recovery twrp-3.5.2_9-0-cedric.img
fastboot boot twrp-3.5.2_9-0-cedric.img
}

echo " Welcome to the Automatic Flashing tool for the Motorola G5 ('Cedric')"
echo " We are not responsible for any bricked devices"

Interactive_Mode

if [[ $Stock_flash == "1" ]]; then
	Stock_flash
else
	sleep 2
fi

if [[ $TWRP_install == "1" ]]; then
	TWRP_install
else 
	sleep 2
fi

if [[ $Root_device == "1" ]]; then
	Root_device
else
	sleep 2
fi 


Check_Return

printf "Finished, bye now"
