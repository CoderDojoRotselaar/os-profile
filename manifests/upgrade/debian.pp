class profile::upgrade::debian {
  class { 'unattended_upgrades':
    enable       => 1,
    random_sleep => 600,
  }

  file { '/etc/apt/apt.conf':
    ensure  => absent,
  }
}
