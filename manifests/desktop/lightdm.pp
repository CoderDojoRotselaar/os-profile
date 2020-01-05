class profile::desktop::lightdm {
  $coderdojo_user = $::profile::user::coderdojo_user

  exec { "migrate ${coderdojo_user} panels":
    command     => '/usr/lib/x86_64-linux-gnu/xfce4/panel/migrate',
    refreshonly => true,
    subscribe   => User[$coderdojo_user],
    user        => $coderdojo_user,
  }

  $lightdm_config = {
    'SeatDefaults' => {
      'autologin-user' => $coderdojo_user,
    }
  }

  $lightdm_defaults = {
    path              => '/etc/lightdm/lightdm.conf',
    key_val_separator => '=',
  }

  create_ini_settings($lightdm_config, $lightdm_defaults)
}
