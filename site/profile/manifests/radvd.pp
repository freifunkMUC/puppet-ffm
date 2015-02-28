class profile::radvd (
  $ipv6_prefix_without_length,
  $ipv6_prefix_length,
  $announce_router=false,
) {

  include ::profile::batman_adv

  contain ::radvd

  $hex_gateway_number = inline_template("<%= ${::profile::batman_adv::gateway_number}.to_i.to_s(16) -%>")
  $rdnss              = "${ipv6_prefix_without_length}${hex_gateway_number}"
  $ipv6_prefix        = "${ipv6_prefix_without_length}/${ipv6_prefix_length}"

  ::radvd::interface { $::profile::batman_adv::bridge:
    options => {
      'AdvSendAdvert'      => 'on',
      'MaxRtrAdvInterval'  => 100,
      'AdvDefaultLifetime' => $announce_router ? {
        true  => 100,
        false => 0,
      },
    },
    prefixes => {
      "${ipv6_prefix}" => {},
    },
    rdnss => {
      "${rdnss}" => {}
    }
  }

  Exec["/sbin/ifup ${::profile::batman_adv::bridge}"] ~> Class['::radvd::service']

}
