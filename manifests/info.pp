class profile::info {
  package { 'inxi':
    ensure => installed,
  }

  exec { 'update-info':
    command => '/usr/bin/inxi -Firxxx -c 0 > /tmp/machine-info',
    require => Package['inxi'],
  }

  file { "${::profile::user::coderdojo_home}/projects/machines/${::hostname}.info":
    source  => '/tmp/machine-info',
    owner   => $::profile::user::coderdojo_user,
    group   => $::profile::user::coderdojo_group,
    require => [
      Exec['update-info'],
      File["${::profile::user::coderdojo_home}/projects"],
    ],
  }

  exec { 'update-facts':
    command => '/opt/puppetlabs/bin/facter -p --json > /tmp/machine-facts',
  }

  file { "${::profile::user::coderdojo_home}/projects/machines/${::hostname}.facts":
    source  => '/tmp/machine-facts',
    owner   => $::profile::user::coderdojo_user,
    group   => $::profile::user::coderdojo_group,
    require => [
      Exec['update-facts'],
      File["${::profile::user::coderdojo_home}/projects"],
    ],
  }
}
