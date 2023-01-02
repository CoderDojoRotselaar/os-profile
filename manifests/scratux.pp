class profile::scratux {
  $coderdojo_home = $::profile::user::coderdojo_home

  package { 'scratux':
    ensure   => installed,
  }

  file { "${coderdojo_home}/Bureaublad/scratux.desktop":
    ensure  => file,
    source  => '/usr/share/applications/scratux.desktop',
    owner   => $::profile::user::coderdojo_user,
    group   => $::profile::user::coderdojo_group,
    mode    => '0644',
    require => Package['scratux'],
  }
}
