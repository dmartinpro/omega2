#! /bin/sh


LIBEXIF=libexif_0.6.21-1_mipsel_24kc.ipk
MINIDLNA=minidlna_1.2.1-2_mipsel_24kc.ipk
BWMNG=bwm-ng_0.6.1-1_mipsel_24kc.ipk

# Update Omega2 opkg cache
opkg update

# Don't upgrade yet all Omega2's apps and libs as it seems it breaks things...
# eval $(opkg list_installed | sed 's/ - .*//' | sed 's/^/opkg upgrade /')

# Install minidlna and its dependency

wget https://downloads.lede-project.org/snapshots/packages/mipsel_24kc/packages/$LIBEXIF
opkg install $LIBEXIF
rm $LIBEXIF
wget https://downloads.lede-project.org/snapshots/packages/mipsel_24kc/packages/$MINIDLNA
opkg install $MINIDLNA
rm $MINIDLNA

# Get the configuration
wget https://raw.githubusercontent.com/dmartinpro/omega2/master/mobilemediaserver/minidlna.conf
mv minidlna.conf /etc/config/minidlna

# Change a few things in order to let the service works as expected (late start and perform a rebuild action of the database)
sed -i -e 's/START=50/START=99/g' /etc/init.d/minidlna
sed -i -e 's/\/usr\/bin\/minidlna -f/\/usr\/bin\/minidlna -r -f/g' /etc/init.d/minidlna

# Install network tool BWM-NG
wget https://downloads.lede-project.org/snapshots/packages/mipsel_24kc/packages/$BWMNG
opkg install $BWMNG
rm $BWMNG

# enable minidlna
/etc/init.d/minidlna enable

# reload the configuration
/etc/init.d/minidlna reload

# Housekeeping...
rm setup.sh
rm .wget*

# Install power-dock package
opkg install power-dock

# Switch on power LED every minutes
#(crontab -l 2>/dev/null; echo "*/1 * * * * /power-dock -with args") | crontab -
#/etc/init.d/cron restart

# Switch on power LED every 10 seconds
wget https://raw.githubusercontent.com/dmartinpro/omega2/master/mobilemediaserver/battery-level.sh
chmod +x battery-level.sh
sed -i -e 's/exit 0/sh \/root\/battery-level.sh &\n\nexit 0/g' /etc/rc.local 

# All done
echo "Everything is (should be) ok, now add media to the microsd card"
