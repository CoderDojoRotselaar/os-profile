class profile::desktop::lubuntu {
  package { 'lubuntu-desktop':
    ensure => installed,
  }
  service { 'lightdm':
    ensure => enabled,
  }
}
