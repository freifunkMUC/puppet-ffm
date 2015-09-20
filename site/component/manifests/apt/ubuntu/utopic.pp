class component::apt::ubuntu::utopic (
  $mirror='de.archive.ubuntu.com',
  $repos=['main', 'universe'],
) {
  $repos_str = join($repos, ' ')

  apt::source { "ubuntu_utopic_${mirror}":
    location    => "http://${mirror}/ubuntu/",
    repos       => $repos_str,
    release     => 'utopic',
    include_src => false,
  }
}
