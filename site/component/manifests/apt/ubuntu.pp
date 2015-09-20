class component::apt::ubuntu (
  $mirror='de.archive.ubuntu.com',
  $repos=['main', 'universe'],
) {
  $repos_str = join($repos, ' ')

  apt::source { "ubuntu_${mirror}":
    location => "http://${mirror}/ubuntu/",
    repos    => $repos_str,
    include  => { 'deb' => true, 'src' => false },
  }

  apt::source { "ubuntu-updates_${mirror}":
    location => "http://${mirror}/ubuntu/",
    repos    => $repos_str,
    release  => "${::lsbdistcodename}-updates",
    include  => { 'deb' => true, 'src' => false },
  }

  apt::source { "ubuntu-security_${mirror}":
    location => "http://${mirror}/ubuntu/",
    repos    => $repos_str,
    release  => "${::lsbdistcodename}-security",
    include  => { 'deb' => true, 'src' => false },
  }

  apt::source { "ubuntu-backports_${mirror}":
    location => "http://${mirror}/ubuntu/",
    repos    => $repos_str,
    release  => "${::lsbdistcodename}-backports",
    include  => { 'deb' => true, 'src' => false },
  }
}
