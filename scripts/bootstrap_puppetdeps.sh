#!/bin/bash

sudo apt-get -y upgrade
curl https://apt.puppetlabs.com/puppetlabs-release-trusty.deb -O
sudo dpkg -i puppetlabs-release-trusty.deb
sudo apt-get update

sudo apt-get -y install git puppet facter make ruby-dev
sudo gem install librarian-puppet