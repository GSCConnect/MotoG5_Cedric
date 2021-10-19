#!/bin/bash 

echo "Hello, this will flash your Motorola Credic back into stock firmware"

echo -----------------------------------------------------------------
sleep 4
echo "Be advised this will deleted EVERYTHING IN YOUR DEVICE, I am not responsible for any bricked devices"
sleep 4
read -p "If you are ok with this, type yes to continue or type no to exit this script" $user_ans
echo ""
if [[ $user_ans == "yes"]]; then 
  echo "alright lets flash"
else 
  exit
fi

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
fastboot reboot

echo "Flashing is finished, good bye ninja"
