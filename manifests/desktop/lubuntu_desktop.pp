class profile::desktop::lubuntu_desktop (
  Integer $desktops = 1,
) {
  include ::profile::desktop::lightdm

  package { [
    'wmctrl', 'lubuntu-desktop',
  ]:
    ensure => installed,
    before => User[$::profile::user::coderdojo_user],
  }

  file { "${::profile::user::coderdojo_home}/.config/clipit":
    ensure => directory,
    owner  => $::profile::user::coderdojo_user,
    group  => $::profile::user::coderdojo_group,
  }

  file { [
    "${::profile::user::coderdojo_home}/.config/pcmanfm/",
    "${::profile::user::coderdojo_home}/.config/lxpanel",
  ]:
    ensure  => absent,
    recurse => true,
    purge   => true,
    force   => true,
  }

  file { "${::profile::user::coderdojo_home}/.config/lxqt/panel.conf":
    ensure  => present,
    content => file('profile/lubuntu_desktop/lxqt_panel.conf'),
    owner   => $::profile::user::coderdojo_user,
    group   => $::profile::user::coderdojo_group,
  }

  file { "${::profile::user::coderdojo_home}/.config/clipit/clipitrc":
    ensure  => present,
    content => file('profile/lubuntu_desktop/clipitrc'),
    owner   => $::profile::user::coderdojo_user,
    group   => $::profile::user::coderdojo_group,
  }

  file { "${::profile::user::coderdojo_home}/.config/pcmanfm-qt/lxqt/settings.conf":
    ensure  => present,
    content => file('profile/lubuntu_desktop/lxqt_settings.conf'),
    owner   => $::profile::user::coderdojo_user,
    group   => $::profile::user::coderdojo_group,
  }

  exec { "Set number of desktops to ${desktops}":
    environment => 'DISPLAY=:0',
    command     => "/usr/bin/wmctrl -n ${desktops}",
    user        => $::profile::user::coderdojo_user,
    unless      => "/usr/bin/wmctrl -d | /usr/bin/wc -l | grep -Fx ${desktops}",
    require     => Package['wmctrl'],
  }
}
