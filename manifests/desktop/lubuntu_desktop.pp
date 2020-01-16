class profile::desktop::lubuntu_desktop (
  Integer $desktops = 1,
) {
  package { ['lubuntu-desktop', 'wmctrl']:
    ensure => installed,
    before => User[$::profile::user::coderdojo_user],
  }

  $unquoted_ini = {
    'quote_char' => '',
  }

  $desktop_config = {
    '*' => {
      'wallpaper_mode'        => 'crop',
      'wallpaper_common'      => 1,
      'wallpapers_configured' => 1,
      'wallpaper'             => '/usr/share/backgrounds/coderdojo/coderdojo_background.png',
      'wallpaper0'            => '/usr/share/backgrounds/coderdojo/coderdojo_background.png',
      'desktop_bg'            => '#2e4060',
      'desktop_fg'            => '#ffffff',
      'desktop_shadow'        => '#000000',
      'desktop_font'          => 'Ubuntu 11',
      'show_wm_menu'          => 0,
      'sort'                  => 'mtime;ascending;',
      'show_documents'        => 1,
      'show_trash'            => 1,
      'show_mounts'           => 1,
    },
  }

  file { [
    "${::profile::user::coderdojo_home}/.config/pcmanfm",
    "${::profile::user::coderdojo_home}/.config/pcmanfm/lubuntu",
    "${::profile::user::coderdojo_home}/.config/lxpanel",
    "${::profile::user::coderdojo_home}/.config/lxpanel/Lubuntu",
    "${::profile::user::coderdojo_home}/.config/lxpanel/Lubuntu/panels",
  ]:
    ensure => directory,
    owner  => $::profile::user::coderdojo_user,
    group  => $::profile::user::coderdojo_group,
  }

  file { "${::profile::user::coderdojo_home}/.config/pcmanfm/lubuntu/desktop-items-0.conf":
    ensure  => present,
    content => hash2ini($desktop_config, $unquoted_ini),
    owner   => $::profile::user::coderdojo_user,
    group   => $::profile::user::coderdojo_group,
  }

  file { "${::profile::user::coderdojo_home}/.config/lxpanel/Lubuntu/panels/panel":
    ensure  => present,
    content => file('profile/lubuntu_desktop/panels.conf'),
    owner   => $::profile::user::coderdojo_user,
    group   => $::profile::user::coderdojo_group,
    notify  => Exec['Restart lxpanel'],
  }

  exec { 'Restart lxpanel':
    command     => '/usr/bin/lxpanelctl restart',
    user        => $::profile::user::coderdojo_user,
    refreshonly => true,
  }
  exec { "Set number of desktops to ${desktops}":
    environment => 'DISPLAY=:0',
    command     => "/usr/bin/wmctrl -n ${desktops}",
    user        => $::profile::user::coderdojo_user,
    unless      => "/usr/bin/wmctrl -d | /usr/bin/wc -l | grep -Fx ${desktops}",
  }
}
