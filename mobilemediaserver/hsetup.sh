#! /bin/bash

# Configure Wifi

# wifisetup add -ssid <SSID> -encr <ENCRYPTION TYPE> -password <PASSWORD>

# Upgrade Firmware if needed

oupgrade

# Prepare the console setup for the next reboot

uci set onion.console.setup=1
uci set onion.console.install=2
uci commit onion

# Then reboot
reboot
