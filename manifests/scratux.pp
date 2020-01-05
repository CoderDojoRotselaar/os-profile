class profile::scratux {
  $coderdojo_home = $::profile::user::coderdojo_home

  case $facts['os']['family'] {
    'RedHat': { include profile::scratux::redhat  }
    'Debian': { include profile::scratux::debian  }
    default:  { } # do nothing
  }

  file { "${coderdojo_home}/Bureaublad/scratux.desktop":
    ensure  => file,
    source  => '/usr/share/applications/scratux.desktop',
    owner   => $::profile::user::coderdojo_user,
    group   => $::profile::user::coderdojo_group,
    require => Package['scratux'],
  }
}
