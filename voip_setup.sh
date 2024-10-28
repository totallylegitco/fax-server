#!/bin/bash
set -ex


# FSfile=$(curl -s https://files.freeswitch.org/releases/freeswitch/ | grep -oE "freeswitch-[0-9]*\.[0-9]*\.[0-9]*\.-release\.tar\.bz2" | tail -n 1) && echo Downloading $FSfile && curl https://files.freeswitch.org/freeswitch-releases/$FSfile | tar -xj && mv ${FSfile/.tar.bz2//} freeswitch && cd freeswitch && ./bootstrap.sh -j && ./configure && make && make install
echo "Using $SW_TOKEN"

wget --http-user=signalwire --http-password="$SW_TOKEN" -O /usr/share/keyrings/signalwire-freeswitch-repo.gpg https://freeswitch.signalwire.com/repo/deb/debian-release/signalwire-freeswitch-repo.gpg


# Use the bookworm release instead of the ubuntu release
RELEASE=bookworm

echo "machine freeswitch.signalwire.com login signalwire password $SW_TOKEN" > /etc/apt/auth.conf
echo "deb [signed-by=/usr/share/keyrings/signalwire-freeswitch-repo.gpg] https://freeswitch.signalwire.com/repo/deb/debian-release/ $RELEASE main" > /etc/apt/sources.list.d/freeswitch.list
echo "deb-src [signed-by=/usr/share/keyrings/signalwire-freeswitch-repo.gpg] https://freeswitch.signalwire.com/repo/deb/debian-release/ $RELEASE main" >> /etc/apt/sources.list.d/freeswitch.list

apt-get update

apt-get install --yes build-essential pkg-config uuid-dev zlib1g-dev libjpeg-dev libsqlite3-dev libcurl4-openssl-dev libpcre3-dev libspeexdsp-dev libldns-dev libedit-dev libtiff5-dev yasm libopus-dev libsndfile1-dev unzip libavformat-dev libswscale-dev liblua5.2-dev liblua5.2-0 cmake libpq-dev unixodbc-dev autoconf automake ntpdate libxml2-dev libpq-dev libpq5 sngrep lua5.2 lua5.2-doc libreadline-dev

apt-get install hylafax-server freeswitch freeswitch-mod-commands freeswitch-mod-dptools freeswitch-mod-event-socket freeswitch-mod-sofia freeswitch-mod-spandsp freeswitch-mod-tone-stream freeswitch-mod-db freeswitch-mod-syslog freeswitch-mod-logfile



# Setup gofaxip
apt install git dh-golang golang
git clone https://github.com/gonicus/gofaxip
cd gofaxip
dpkg-buildpackage -us -uc -rfakeroot -b
cd ..
dpkg --install gofax*.deb
