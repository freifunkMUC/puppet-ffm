forge 'https://forgeapi.puppetlabs.com'

# r10k specific moduledir '/opt/puppet/modules'

mod 'puppetlabs/apt', '1.7.0'
mod 'thias/sysctl', '1.0.0'

mod 'puppetlabs/firewall',
  :git => "https://github.com/puppetlabs/puppetlabs-firewall.git"

#mod 'puppetlabs/firewall' #, '1.2.0'
# no version pinning because I hope for a fix of the following soon:
#Error: /Stage[main]/Firewall::Linux::Debian/Service[iptables-persistent]: Could not evaluate: Could not find init script for 'iptables-persistent'

mod 'camptocamp-kmod',
  :git => "https://github.com/camptocamp/puppet-kmod.git" #,
#  :ref => '1.0.0'
# patched:
# https://github.com/camptocamp/puppet-kmod/pull/25.patch

