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

  file { "/var/lib/AccountsService/icons/${coderdojo_user}":
    ensure => file,
    source => '/var/lib/coderdojo-deploy/assets/coderdojo_logo.png',
  }

  File { '/etc/dconf/db/local.d/10-gnome_shell',
    ensure  => present,
    content => file('profile/gnome_shell.dconf',
  }

  exec { 'dconf update':
    command     => '/usr/bin/dconf update',
    refreshonly => true,
  }
}
