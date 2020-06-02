class profile::scratux::redhat {
  package { 'scratux-rpm':
    ensure   => absent,
    name     => 'scatux',
    provider => 'yum',
  }
}
