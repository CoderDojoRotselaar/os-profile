class profile::lightdm {
  include ::lightdm

  $coderdojo_user = $::profile::user::coderdojo_user

  class { '::lightdm':
    config => {
      'SeatDefaults' => {
        'user-session'           => 'xfce',
        'allow-guest'            => 'false',
        'autologin-user'         => $coderdojo_user,
        'autologin-user-timeout' => '0',
        'autologin-session'      => 'lightdm-autologin',
        'greeter-setup-script'   => '/usr/bin/numlockx on',
      }
    }
  }
}
