class profile::desktop (
  Optional[String] $background = undef,
  Optional[String] $environment = undef,
) {
  require ::profile::disks

  $installed_des = $facts['desktop_sessions']
  notify { "Currently installed desktop environments: ${installed_des}": }

  if $environment and empty($installed_des) {
    notify { "Installing default DE for this host: '${environment}'": }

    $sanitized_env = regsubst($environment, /[^[:alnum:]+]/, '_', 'G')
    $sanitized_env_class = "profile::desktop::${sanitized_env}"

    include $sanitized_env_class
  }

  case $environment {
    'lubuntu-desktop': {
      $session_name = 'lxqt'
      $xsession_name = 'Lubuntu'

      file {
        '/etc/X11/default-display-manager':
          ensure  => file,
          content => "/usr/sbin/lightdm\n",
          ;
        '/etc/systemd/system/display-manager.service':
          ensure => link,
          target => '/lib/systemd/system/lightdm.service',
          notify => Exec['/bin/systemctl daemon-reload'],
          ;
        '/etc/alternatives/x-session-manager':
          ensure => link,
          target => '/usr/bin/startlxde',
          ;
      }
    }
    'gnome-shell': {
      $session_name = 'lxqt'
      $xsession_name = 'ubuntu'

      file {
        '/etc/X11/default-display-manager':
          ensure  => file,
          content => "/usr/sbin/gdm3\n",
          ;
        '/etc/systemd/system/display-manager.service':
          ensure => link,
          target => '/lib/systemd/system/gdm3.service',
          notify => Exec['/bin/systemctl daemon-reload'],
          ;
        '/etc/alternatives/x-session-manager':
          ensure => link,
          target => '/usr/bin/gnome-session',
          ;
      }
    }
    default: {
      $session_name = 'lxqt'
      $xsession_name = 'ubuntu'
    }
  }

  $lightdm_session_config = {
    'User'         => {
      'Session'       => $session_name,
      'XSession'      => $xsession_name,
      'Icon'          => "${::profile::user::coderdojo_home}/.face",
      'SystemAccount' => false,
    },
    'InputSource0' => {
      'xkb' => $profile::keyboard::layout,
    }
  }

  $lightdm_session_defaults = {
    path              => "/var/lib/AccountsService/users/${::profile::user::coderdojo_user}",
    key_val_separator => '=',
    require           => Package['lightdm'],
  }

  create_ini_settings($lightdm_session_config, $lightdm_session_defaults)


  if $background {
    file {
      '/usr/share/backgrounds':
        ensure => directory
        ;
      '/usr/share/backgrounds/coderdojo':
        ensure => directory
        ;
      '/usr/share/backgrounds/coderdojo/coderdojo_background.png':
        ensure => file,
        source => "/var/lib/puppet-deployment/assets/${background}",
        ;
    }
  }

  file { [
    "${::profile::user::coderdojo_home}/.config",
    "${::profile::user::coderdojo_home}/Bureaublad"
  ]:
    ensure => directory,
    owner  => $::profile::user::coderdojo_user,
    group  => $::profile::user::coderdojo_group,
  }

  $ds_classes = $installed_des.map |String $ds| {
    $sanitized_ds = regsubst($ds, /[^[:alnum:]+]/, '_', 'G')
    "profile::desktop::${sanitized_ds}"
  }

  exec { 'dconf update':
    command     => '/usr/bin/dconf update',
    refreshonly => true,
  }

  include $ds_classes
}
