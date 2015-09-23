#!/bin/bash

STAMP="/var/lib/.puppet_bootstrapped"

if [ ! -e $STAMP ]; then
    curl -Oq https://apt.puppetlabs.com/puppetlabs-release-stable.deb
    dpkg -i puppetlabs-release-stable.deb
    rm puppetlabs-release-stable.deb

    apt-get update
    apt-get upgrade

    apt-get -y install git puppet facter librarian-puppet

    touch "$STAMP"
fi
