class profile::scratux {
  $coderdojo_home = $::profile::user::coderdojo_home

  case $facts['os']['family'] {
    'RedHat': { include profile::scratux::redhat  }
    'Debian': { include profile::scratux::debian  }
    default:  { } # do nothing
  }

  include ::snapd

  package { 'scratux':
    ensure   => installed,
    provider => 'snap',
  }

  file { "${coderdojo_home}/Bureaublad/scratux.desktop":
    ensure  => file,
    source  => '/var/lib/snapd/desktop/applications/scratux_scratux.desktop',
    owner   => $::profile::user::coderdojo_user,
    group   => $::profile::user::coderdojo_group,
    mode    => '0755',
    require => Package['scratux'],
  }
}
