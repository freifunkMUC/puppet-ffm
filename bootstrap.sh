#!/usr/bin/env bash

apt-get -y upgrade
curl https://apt.puppetlabs.com/puppetlabs-release-trusty.deb -O
dpkg -i puppetlabs-release-trusty.deb
apt-get update

apt-get -y install git puppet make ruby-dev gcc facter

gem install librarian-puppet

cd /vagrant
librarian-puppet install