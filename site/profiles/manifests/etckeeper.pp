class profiles::etckeeper {

  include ::apt
  Exec['apt_update'] -> Package <| title != 'etckeeper' and title != 'git' |>

  package { 'git':
  } ->
  package { 'etckeeper':
  } -> File <| |>

}
