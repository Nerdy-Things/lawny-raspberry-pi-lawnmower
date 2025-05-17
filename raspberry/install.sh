#!/bin/bash
sudo apt-get update -y
sudo apt-get install -y git python3 pigpio python3-pigpio

sudo systemctl enable pigpiod

sudo apt install vsftpd

# sudo nano /etc/vsftpd.conf
# write_enable=YES

sudo systemctl restart vsftpd.service

pip3 install websockets --break-system-packages

# pip3 install gpiod --break-system-packages
# pip3 install pigpio --break-system-packages

# https://github.com/Pioreactor/rpi_hardware_pwm
pip3 install rpi-hardware-pwm --break-system-packages
sudo bash -c 'echo "dtoverlay=pwm-2chan,pin=12,func=4,pin2=13,func2=4" >> /boot/firmware/config.txt'

# Get the current kernel version
# current_kernel=$(uname -r)

# https://github.com/Pioreactor/rpi_hardware_pwm/issues/14
# if [[ "$current_kernel" == "6.6.20+rpt-rpi-2712" ]]; then
#   echo "Kernel version has issues. Updating..."
#   sudo apt install raspberrypi-kernel
#   sudo rpi-update
# else
#   echo "Kernel is OK"
# fi

sudo reboot now

