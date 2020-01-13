class profile::desktop::lubuntu {
  package { 'lubuntu-desktop':
    ensure => installed,
    before => User[$::profile::user::coderdojo_user],
  }
  service { 'lightdm':
    ensure => enabled,
  }
}
