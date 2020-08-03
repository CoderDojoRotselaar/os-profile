class profile::networks {
  contain ::profile::wifi

  package { 'network-manager':
    ensure => installed,
  }
}
