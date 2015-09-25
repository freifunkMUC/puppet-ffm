#!/bin/bash

set -e

STAMP="/var/lib/.puppet_bootstrapped"
MOD_STAMP="/vagrant/modules/.stamp"

if [ ! -e "$STAMP" ]; then
    curl -Oq https://apt.puppetlabs.com/puppetlabs-release-stable.deb
    dpkg -i puppetlabs-release-stable.deb
    rm puppetlabs-release-stable.deb

    apt-get update
    apt-get -y upgrade
    apt-get -y install git puppet facter r10k

    touch "$STAMP"
fi

if [ ! -e "$MOD_STAMP" ] || [ "$MOD_STAMP" -ot /vagrant/Puppetfile ]; then
    cd /vagrant

    r10k -v info puppetfile install

    touch "$MOD_STAMP"
fi

