class profile::desktop::gnome_shell {
  $gnome_config = {
    'daemon' => {
      'AutomaticLoginEnable' => 'True',
      'AutomaticLogin'       => 'username',
    }
  }

  $gnome_defaults = {
    path              => '/etc/gdm/custom.conf',
    key_val_separator => '=',
  }

  create_ini_settings($gnome_config, $gnome_defaults)
}
