class profile::desktop::lubuntu {
  $background = $::profile::desktop::background

  package { 'lubuntu-desktop':
    ensure => installed,
    before => User[$::profile::user::coderdojo_user],
  }

  file { [
    "${::profile::user::coderdojo_home}/.config/lxpanel",
    "${::profile::user::coderdojo_home}/.config/lxpanel/Lubuntu",
    "${::profile::user::coderdojo_home}/.config/lxpanel/Lubuntu/panes",
    ]:
      ensure => directory,
      owner  => $::profile::user::coderdojo_user,
      group  => $::profile::user::coderdojo_group,
  }

  file { "${::profile::user::coderdojo_home}/.config/lxpanel/Lubuntu/panes/panel":
    ensure  => file,
    content => template('profile/lubuntu/panel.conf.erb'),
    owner   => $::profile::user::coderdojo_user,
    group   => $::profile::user::coderdojo_group,
  }

  service { 'lightdm':
    ensure => enabled,
  }
}
