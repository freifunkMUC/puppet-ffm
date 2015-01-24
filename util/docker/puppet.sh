#!/bin/bash -xe

wget -nv https://apt.puppetlabs.com/puppetlabs-release-$(lsb_release -cs).deb
dpkg -i puppetlabs-release-$(lsb_release -cs).deb
rm -v puppetlabs-release-$(lsb_release -cs).deb

apt-get update
apt-get install -y puppet

gem install deep_merge
rm -r .gem
