class batman_adv::install {
  include ::batman_adv::module
  package { 'bridge-utils': }
}
