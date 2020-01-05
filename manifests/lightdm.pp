class profile::lightdm {
  $coderdojo_user = $::profile::user::coderdojo_user

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
