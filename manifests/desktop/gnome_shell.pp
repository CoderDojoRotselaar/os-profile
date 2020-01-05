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
    source => '/var/lib/coderdojo-deployment/assets/coderdojo_logo.png',
  }
}
