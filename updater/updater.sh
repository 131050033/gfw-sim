#!/bin/sh
mv /etc/resolv.conf /tmp/resolv.conf
echo "nameserver  8.8.8.8" >/etc/resolve.conf
DEST_PACKAGE="/tmp/gfw.update.tgz"
cd /tmp || exit
# Get update digest
URL="https://raw.githubusercontent.com/phoeagon/gfw-sim/release/releases/digest"
wget --no-check-certificate ${URL} -O /tmp/gfw.digest
# Test if need to update
# : openwrt removes diff!
cmp /etc/gfw.digest /tmp/gfw.digest && exit
PACKAGE=`sed '2q;d' /tmp/gfw.digest`
# Download.
wget --no-check-certificate ${PACKAGE} -O ${DEST_PACKAGE}
# Check checksum
EXPECTED_DIGEST=`head -1 /tmp/gfw.digest`
echo ${EXPECTED_DIGEST}"  "${DEST_PACKAGE} | md5sum -c || exit
tar xf ${DEST_PACKAGE} -C /
cp /tmp/gfw.digest /etc/gfw.digest
# Print Success
echo "OK"
