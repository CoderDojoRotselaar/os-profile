class profile::upgrade::debian {
  class { 'unattended_upgrades':
    enable       => 1,
    random_sleep => 600,
    auto         => {
      clean => 1,
    }
  }

  package { 'update-notifier':
    ensure => installed,
  }

  file { '/etc/xdg/autostart/update-notifier.desktop':
    ensure  => present,
    content => '# Disabled by Puppet',
    require => Package['update-notifier'],
  }
}
