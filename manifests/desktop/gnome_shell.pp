class profile::desktop::gnome_shell {
  $coderdojo_user = $::profile::user::coderdojo_user

  $gnome_config = {
    'daemon' => {
      'AutomaticLoginEnable' => 'True',
      'AutomaticLogin'       => $coderdojo_user,
    }
  }

  $gnome_defaults = {
    path              => '/etc/gdm/custom.conf',
    key_val_separator => '=',
  }

  create_ini_settings($gnome_config, $gnome_defaults)

  file {
    "/var/lib/AccountsService/icons/${coderdojo_user}":
      ensure => file,
      source => '/var/lib/coderdojo-deploy/assets/coderdojo_logo.png',
      ;
    '/etc/dconf/db/local.d/01-coderdojo':
      ensure  => present,
      content => file('profile/01-coderdojo.dconf'),
      require => File['/usr/share/backgrounds/coderdojo/coderdojo_background.png'],
      notify  => Exec['dconf update'],
  }

  if $profile::desktop::background {
    file {'/etc/dconf/db/local.d/10-gnome_shell':
      ensure  => present,
      content => file('profile/gnome_shell.dconf'),
      require => File['/usr/share/backgrounds/coderdojo/coderdojo_background.png'],
      notify  => Exec['dconf update'],
    }
  }

  exec { 'dconf update':
    command     => '/usr/bin/dconf update',
    refreshonly => true,
  }
}
