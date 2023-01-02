class profile::desktop::lubuntu_desktop (
  Integer $desktops = 1,
) {
  include ::profile::desktop::lightdm

  package { 'lubuntu-desktop':
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

  file { "${::profile::user::coderdojo_home}/.config/openbox/lxqt-rc.xml":
    ensure  => present,
    content => file('profile/lubuntu_desktop/lxqt-rc.xml'),
    owner   => $::profile::user::coderdojo_user,
    group   => $::profile::user::coderdojo_group,
  }
}
