class profile::upgrade {
  case $facts['os']['family'] {
    'RedHat': { include ::profile::upgrade::redhat  }
    'Debian': { include ::profile::upgrade::debian  }
    default:  { } # do nothing
  }
}
