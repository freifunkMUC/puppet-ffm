class component::apt::debian (
  $mirror='httpredir.debian.org',
  $repos=['main'],
  $updates=true,
  $backports=true,
) {
  $repos_str = join($repos, ' ')

  Apt::Source {
    include  => {
      deb => true,
      src => false
    },
  }

  apt::source { "debian_${mirror}":
    location => "http://${mirror}/debian/",
    repos    => $repos_str,
  }

  apt::source { "ubuntu-security_${mirror}":
    location => 'http://security.debian.org/',
    repos    => $repos_str,
    release  => "${::lsbdistcodename}/updates",
  }

  apt::source { "debian-updates ${mirror}":
    location => "http://${mirror}/debian/",
    repos    => $repos_str,
    release  => "${::lsbdistcodename}-updates",
  }

  apt::source { "debian-backports_${mirror}":
    location => "http://${mirror}/debian/",
    repos    => $repos_str,
    release  => "${::lsbdistcodename}-backports",
  }
}
