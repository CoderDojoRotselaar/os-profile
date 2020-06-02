class profile::scratux::redhat {
  $rpm = 'https://github.com/scratux/scratux/releases/download/v1.2/scratux-1.2.0.x86_64.rpm'

  package { 'scratux':
    ensure   => absent,
    provider => 'yum',
    source   => $rpm,
  }
}
