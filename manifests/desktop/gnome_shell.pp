class profile::desktop::gnome_shell {
  $coderdojo_user = $::profile::user::coderdojo_user

  package { 'gnome-shell':
    ensure => installed,
    before => User[$::profile::user::coderdojo_user],
  }


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
  }
}
