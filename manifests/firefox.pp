class profile::firefox {
  $coderdojo_home = $::profile::user::coderdojo_home

  package { 'firefox':
    ensure => installed,
  }

  file { "${coderdojo_home}/Bureaublad/firefox.desktop":
    ensure  => file,
    source  => '/usr/share/applications/firefox.desktop',
    owner   => $::profile::user::coderdojo_user,
    group   => $::profile::user::coderdojo_group,
    mode    => '0755',
    require => Package['firefox'],
  }
}
