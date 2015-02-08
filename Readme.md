# puppet-ffm

These are puppet manifests to set up Freifunk gateways and servers that are
compatible with the gluon firmware. The goal is to keep them as general and
configurable as possible to be used in other communities.

Status: *very experimental*

# what's missing right now
- no intercity-vpn yet

## warning
You should set up a vpn for the traffic which will flow through the
new gateway.
Until that you should probably stop fastd with "service fastd stop".

# base system

As a first step you should install ubuntu 14.04 lts on your machine.


# bootstrapping the installation
```
sudo apt-get -y upgrade
curl https://apt.puppetlabs.com/puppetlabs-release-trusty.deb -O
sudo dpkg -i puppetlabs-release-trusty.deb
sudo apt-get update

sudo apt-get -y install git puppet make ruby-dev
sudo gem install librarian-puppet

cd /opt
sudo git clone https://github.com/freifunkMUC/puppet-ffm.git
sudo chown -R $USER:$USER puppet-ffm
cd puppet-ffm
librarian-puppet install
```

# configuration
```
$EDITOR hieradata/hosts/$(facter fqdn).yaml
```

If you are not on the system which should be changed, you need to
use the fqdn of the corresponding virtual machine as the name of
the yaml-file.

Example hieradata/hosts/$(facter fqdn).yaml file:
```
---

role: gateway

profile::fastd::community: ffmuc
profile::batman_adv::bridge: brffmuc
profile::batman_adv::version: '2014.4'

profile::dhcpd::range_start: '10.80.4.1'
profile::dhcpd::range_end: '10.80.4.254'
profile::dhcpd::subnet: '10.80.0.0'

profile::batman_adv::netmask: '255.255.0.0'
profile::batman_adv::gateway_ip: '10.80.0.4'
profile::batman_adv::gateway_number: 4

fastd::secret_key: 'INSERT SECRET KEY'
fastd::public_key: 'INSERT PUBLIC KEY'

profile::openvpn::configs:
  mullvad1:
    vpn_routing_table: 'freifunk'
    dependent_services:
      - 'dnsmasq'
    provider_fqdns:
      - 'se.mullvad.net'
    port: 1194
    provider: 'mullvad'

profile::openvpn::configs:
  ipred1:
    vpn_routing_table: '123'
    username: 'testsepp'
    password: 'testpass'
    dependent_services:
      - 'dnsmasq'
    provider: 'ipredator'


```

- `profile::batman_adv::gateway_number`: anything from 1 to 255
- `fastd::secret_key`: you need to provide this key by yourself by using
  the command `fastd --generate-key`
- `fastd::public_key`: you need to provide this key by yourself by using
  the command `fastd --generate-key`
- vpn_service: which vpn-provider do you use? right now it is only mullvad
               supported but it should be rather easy to adjust to others


You should also have a look at `hieradata/common.yaml` which has
several default parameters set. This data however gets overwritten
by the more specific file `hieradata/$( facter fqdn ).yaml`.

If you would like to use Vagrant for setting up a Virtual Machine
you will need to create and change `configs.yaml` as well.

In the configs.yaml which comes with the code you can see a working
example. The one thing you need to change for sure is `boxname`.
Use the name of a ubuntu 14.04.1_lts vagrant-box you prepared or
downloaded for this purpose.
The example-file also refers to a provider `libvirt` which you may
install with `vagrant plugin install vagrant-libvirt`.


#### box behind nat
Please look up how to set up the right firewall-rules for your operating
system to forward the fastd-port to your Virtual Machine if you want to
use this kind of setup.


#### With Vagrant
After you modified `configs.yaml` to your needs, you may type
`vagrant up hostname` into your terminal.
Have a look at `Vagrantfile` to see what will be used.
Make sure, that your Operating System is allowing you to add the NFS-folders
and that the firewall is not blocking nfs.


#### Without Vagrant
This changes the configuration and packages of your machine where you
are logged in right now!
Etckeeper comes with this installation so you may check for changes there as well.

```
sudo ./apply.sh
```

#### A new Kernel for Ubuntu 14.04. LTS
Because puppet installed you a new kernel, you need to reboot your machine.


# using mullvad as vpn-service
append to hieradata/hosts/$FQDN.yaml:
```
profile::openvpn::configs:
  mullvad1:
    vpn_routing_table: 'freifunk'
    dependent_services:
      - 'dnsmasq'
    provider_fqdns:
      - 'se.mullvad.net'
    port: 1194
    provider: 'mullvad'
```

copy your `mullvadconfig.zip` to `puppet-ffm/site/openvpn/files/configs/mullvad1_config.zip`
before you are starting puppet. Keep in mind, that the first part of the file name
will be the name of the config. As you can see in the example above, `mullvad1` is the
name of the first key of the `openvpn::configs-hash`.


# fastd clients
In the file `hieradata/client-peers.yaml` exists an array of public keys of
fastd clients.

```
---

fastd::client_pubkeys:
  - 'insert first key here...'
  - 'insert second key here...'
  - 'insert third key here...'
  - '...'
```

If you change the client-peers you should just run puppet again, either with
`sudo ./apply.sh` or with `vagrant provision`.

# fastd servers
In the file `hieradata/server-peers.yaml` may a hash of fastd-data of other
gateways exist.

```
---
fastd::server_peers:
  fastd.example.com:
    public_key: '...'
    fastd_port: 10000
    contact: 'contact@example.com'
```

# code checking & testing

For syntax and lint checking install the ruby dependencies i.e. with `bundler`
and call `rake`:

```
bundle install --path vendor/bundle
bundle exec rake
```

Use `bundle update` to keep your Gems up-to-date.

