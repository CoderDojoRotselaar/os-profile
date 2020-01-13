class profile::codium {
  $coderdojo_home = $::profile::user::coderdojo_home

  case $facts['os']['family'] {
    'RedHat': { include profile::codium::redhat  }
    'Debian': { include profile::codium::debian  }
    default:  { } # do nothing
  }

  file { "${coderdojo_home}/Bureaublad/codium.desktop":
    ensure  => file,
    source  => '/usr/share/applications/codium.desktop',
    owner   => $::profile::user::coderdojo_user,
    group   => $::profile::user::coderdojo_group,
    mode    => '0755',
    require => Package['codium'],
  }
}
