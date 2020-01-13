class profile::vscodium {
  $coderdojo_home = $::profile::user::coderdojo_home

  case $facts['os']['family'] {
    'RedHat': { include profile::vscodium::redhat  }
    'Debian': { include profile::vscodium::debian  }
    default:  { } # do nothing
  }

  file { "${coderdojo_home}/Bureaublad/vscodium.desktop":
    ensure  => file,
    source  => '/usr/share/applications/vscodium.desktop',
    owner   => $::profile::user::coderdojo_user,
    group   => $::profile::user::coderdojo_group,
    mode    => '0755',
    require => Package['vscodium'],
  }
}
