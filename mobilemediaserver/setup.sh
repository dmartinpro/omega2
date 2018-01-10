#! /bin/bash

# Install minidlna and its dependency

wget http://downloads.lede-project.org/snapshots/packages/mipsel_24kc/packages/libexif_0.6.21-1_mipsel_24kc.ipk
opkg install libexif_0.6.21-1_mipsel_24kc.ipk
wget http://downloads.lede-project.org/snapshots/packages/mipsel_24kc/packages/minidlna_1.2.1-2_mipsel_24kc.ipk
opkg install minidlna_1.2.1-2_mipsel_24kc.ipk

# Get the configuration
wget https://raw.githubusercontent.com/dmartinpro/omega2/master/mobilemediaserver/minidlna.conf
mv minidlna.conf /etc/config/minidlna

# Change a few things in order
sed -i -e 's/START=50/START=99/g' /etc/init.d/minidnla
sed -i -e 's/\/usr\/bin\/minidlna -f/\/usr\/bin\/minidlna -R -f/g' /etc/init.d/minidlna

# Install network tool BWM-NG
wget http://downloads.lede-project.org/snapshots/packages/mipsel_24kc/packages/bwm-ng_0.6.1-1_mipsel_24kc.ipk
opkg install bwm-ng_0.6.1-1_mipsel_24kc.ipk 

# enable minidlna
/etc/init.d/minidlna enable

# reload the configuration
/etc/init.d/minidlna reload

echo "Everything is ok"
