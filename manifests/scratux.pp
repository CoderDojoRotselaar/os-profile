class profile::scratux {
  case $facts['os']['family'] {
    'RedHat': { include profile::scratux::redhat  }
    'Debian': { include profile::scratux::debian  }
    default:  { } # do nothing
  }
}
