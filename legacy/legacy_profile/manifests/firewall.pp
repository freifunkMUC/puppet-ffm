class profile::firewall (
  $purge = false,
) {

  if str2bool($purge) {
    resources { 'firewall':
      purge => true,
    }
  }

}
