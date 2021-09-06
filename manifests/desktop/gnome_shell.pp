class profile::desktop::gnome_shell {
  $coderdojo_user = $::profile::user::coderdojo_user

  $gnome_config = {
    'daemon' => {
      'AutomaticLoginEnable' => 'True',
      'AutomaticLogin'       => $coderdojo_user,
    }
  }

  $gnome_defaults = {
    path              => $facts['gdm_custom_conf_file'],
    key_val_separator => '=',
  }

  create_ini_settings($gnome_config, $gnome_defaults)

  file {
    "/var/lib/AccountsService/icons/${coderdojo_user}":
      ensure => file,
      source => '/var/lib/puppet-deployment/assets/coderdojo_logo.png',
      ;
    '/etc/dconf/db/local.d/':
      ensure => directory,
      ;
    '/etc/dconf/db/local.d/01-coderdojo':
      ensure  => present,
      content => file('profile/gnome_shell/01-coderdojo.dconf'),
      require => File['/usr/share/backgrounds/coderdojo/coderdojo_background.png'],
      notify  => Exec['dconf update'],
      ;
    '/etc/dconf/profile/user':
      ensure  => present,
      content => file('profile/gnome_shell/user.conf'),
      ;
  }

  if $profile::desktop::background {
    file {'/etc/dconf/db/local.d/10-gnome_shell':
      ensure  => present,
      content => file('profile/gnome_shell/gnome_shell.dconf'),
      require => File['/usr/share/backgrounds/coderdojo/coderdojo_background.png'],
      notify  => Exec['dconf update'],
    }
  }

  exec { 'dconf update':
    command     => '/usr/bin/dconf update',
    refreshonly => true,
  }
}
