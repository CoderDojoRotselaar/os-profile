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

  file { "${::profile::user::coderdojo_home}/.face":
    ensure => file,
    source => '/var/lib/coderdojo-deploy/assets/coderdojo_logo.png',
  }

  if $profile::desktop::background {
    $background_path = '/usr/share/backgrounds/coderdojo/coderdojo_background.png'
    $property_name = '/backdrop/screen0/monitor0/workspace0/last-image'
    exec {'update background':
      user    => $coderdojo_user,
      path    => '/usr/bin:/bin:/snap/bin',
      command => "xfconf-query --channel xfce4-desktop --property '${property_name}' --set '${background_path}'",
      unless  => "xfconf-query --channel xfce4-desktop --property '${property_name}' | grep -q '^${background_path}$'",
      require => File[$background_path],
    }
  }
}
