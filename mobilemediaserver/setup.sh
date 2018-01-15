#! /bin/sh


LIBEXIF=libexif_0.6.21-1_mipsel_24kc.ipk
MINIDLNA=minidlna_1.2.1-2_mipsel_24kc.ipk
BWMNG=bwm-ng_0.6.1-1_mipsel_24kc.ipk

# Update Omega2 opkg cache
opkg update

# Don't upgrade yet all Omega2's apps and libs as it seems it breaks things...
# eval $(opkg list_installed | sed 's/ - .*//' | sed 's/^/opkg upgrade /')

# Install minidlna and its dependency

wget http://downloads.lede-project.org/snapshots/packages/mipsel_24kc/packages/$LIBEXIF
opkg install $LIBEXIF
rm $LIBEXIF
wget http://downloads.lede-project.org/snapshots/packages/mipsel_24kc/packages/$MINIDLNA
opkg install $MINIDLNA
rm $MINIDLNA

# Get the configuration
wget https://raw.githubusercontent.com/dmartinpro/omega2/master/mobilemediaserver/minidlna.conf
mv minidlna.conf /etc/config/minidlna

# Change a few things in order to let the service works as expected (late start and perform a rebuild action of the database)
sed -i -e 's/START=50/START=99/g' /etc/init.d/minidlna
sed -i -e 's/\/usr\/bin\/minidlna -f/\/usr\/bin\/minidlna -r -f/g' /etc/init.d/minidlna

# Install network tool BWM-NG
wget http://downloads.lede-project.org/snapshots/packages/mipsel_24kc/packages/$BWMNG
opkg install $BWMNG
rm $BWMNG

# enable minidlna
/etc/init.d/minidlna enable

# reload the configuration
/etc/init.d/minidlna reload

# Housekeeping...
rm setup.sh

echo "Everything is (should be) ok, now add media to the microsd card"
