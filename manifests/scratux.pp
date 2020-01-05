class profile::scratux {
  case $facts['os']['family'] {
    'RedHat': { include profile::scratux::redhat  }
    'Debian': { include profile::scratux::debian  }
    default:  { } # do nothing
  }

  package { 'scratux':
    ensure => installed,
  }

  file { "${coderdojo_home}/Bureaublad/scratux.desktop":
    ensure => link,
    target => '/usr/share/applications/scratux.desktop',
  }
}
