class profile::desktop::lightdm {
  $coderdojo_user = $::profile::user::coderdojo_user

  package { ['lightdm', 'xfce4-panel', 'xfconf']:
    ensure => installed,
  }

  exec { "migrate ${coderdojo_user} panels":
    command     => '/usr/lib/x86_64-linux-gnu/xfce4/panel/migrate',
    refreshonly => true,
    subscribe   => User[$coderdojo_user],
    user        => $coderdojo_user,
    require     => Package['xfce4-panel'],
  }

  $lightdm_config = {
    'SeatDefaults' => {
      'autologin-user' => $coderdojo_user,
    }
  }

  $lightdm_defaults = {
    path              => '/etc/lightdm/lightdm.conf',
    key_val_separator => '=',
    require           => Package['lightdm'],
  }

  create_ini_settings($lightdm_config, $lightdm_defaults)

  $lightdm_session_config = {
    'User'         => {
      'Session'       => $profile::desktop::session_name,
      'XSession'      => $profile::desktop::xsession_name,
      'Icon'          => "/home/${coderdojo_user}/.face",
      'SystemAccount' => false,
    },
    'InputSource0' => {
      'xkb' => $profile::keyboard::layout,
    }
  }

  $lightdm_session_defaults = {
    path              => '/var/lib/AccountsService/users/coderdojo',
    key_val_separator => '=',
    require           => Package['lightdm'],
  }

  create_ini_settings($lightdm_session_config, $lightdm_session_defaults)

  file { "${::profile::user::coderdojo_home}/.face":
    ensure => file,
    source => '/var/lib/puppet-deployment/assets/coderdojo_logo.png',
    owner  => $coderdojo_user,
    group  => $::profile::user::coderdojo_group,
  }

  apt::conf { 'update-notifier':
    priority => 99,
    content  => '',
  }

  if $profile::desktop::background and !('lubuntu-desktop' in $profile::desktop::installed_des) {
    $background_path = '/usr/share/backgrounds/coderdojo/coderdojo_background.png'
    $property_name = '/backdrop/screen0/monitor0/workspace0/last-image'
    exec {'update background':
      user    => $coderdojo_user,
      path    => '/usr/bin:/bin:/snap/bin',
      command => "xfconf-query --channel xfce4-desktop --property '${property_name}' --set '${background_path}'",
      unless  => "xfconf-query --channel xfce4-desktop --property '${property_name}' | grep -q '^${background_path}$'",
      require => [File[$background_path], Package['xfconf']],
    }
  }
}
