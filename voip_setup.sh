#!/bin/bash
set -ex


# FSfile=$(curl -s https://files.freeswitch.org/releases/freeswitch/ | grep -oE "freeswitch-[0-9]*\.[0-9]*\.[0-9]*\.-release\.tar\.bz2" | tail -n 1) && echo Downloading $FSfile && curl https://files.freeswitch.org/freeswitch-releases/$FSfile | tar -xj && mv ${FSfile/.tar.bz2//} freeswitch && cd freeswitch && ./bootstrap.sh -j && ./configure && make && make install
echo "Using $SW_TOKEN"

wget --http-user=signalwire --http-password="$SW_TOKEN" -O /usr/share/keyrings/signalwire-freeswitch-repo.gpg https://freeswitch.signalwire.com/repo/deb/debian-release/signalwire-freeswitch-repo.gpg

echo "machine freeswitch.signalwire.com login signalwire password $TOKEN" > /etc/apt/auth.conf
echo "deb [signed-by=/usr/share/keyrings/signalwire-freeswitch-repo.gpg] https://freeswitch.signalwire.com/repo/deb/debian-release/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/freeswitch.list
echo "deb-src [signed-by=/usr/share/keyrings/signalwire-freeswitch-repo.gpg] https://freeswitch.signalwire.com/repo/deb/debian-release/ $(lsb_release -sc) main" >> /etc/apt/sources.list.d/freeswitch.list

apt-get update
