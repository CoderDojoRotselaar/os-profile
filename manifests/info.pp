class profile::info {
  package { 'inxi':
    ensure => installed,
  }

  exec { 'update-info':
    command => '/usr/bin/inxi -F -c 0 > /tmp/machine-info',
    require => Package['inxi'],
  }

  file { "${::profile::user::coderdojo_home}/projects/machines/${::hostname}.info":
    source  => '/tmp/machine-info',
    require => [
      Exec['update-info'],
      File["${::profile::user::coderdojo_home}/projects"],
    ],
  }
}
