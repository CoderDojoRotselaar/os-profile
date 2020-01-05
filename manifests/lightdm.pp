class profile::lightdm {
  $coderdojo_user = $::profile::user::coderdojo_user

  $lightdm_config = {
    'SeatDefaults' => {
      'user-session'           => 'xfce',
      'allow-guest'            => 'false',
      'autologin-user'         => $coderdojo_user,
      'autologin-user-timeout' => '0',
      'autologin-session'      => 'lightdm-autologin',
      'greeter-setup-script'   => '/usr/bin/numlockx on',
    }
  }

  $lightdm_defaults = {
    key_val_separator => '=',
    path              => '/tmp/foo.ini'
  }

  create_ini_settings($lightdm_config, $lightdm_defaults)
}
