#! /bin/bash

wget http://downloads.lede-project.org/snapshots/packages/mipsel_24kc/packages/libexif_0.6.21-1_mipsel_24kc.ipk
opkg install libexif_0.6.21-1_mipsel_24kc.ipk
wget http://downloads.lede-project.org/snapshots/packages/mipsel_24kc/packages/minidlna_1.2.1-2_mipsel_24kc.ipk
opkg install minidlna_1.2.1-2_mipsel_24kc.ipk

wget minidlna.conf
mv minidlna.conf /etc/config/minidlna

sed
sed

