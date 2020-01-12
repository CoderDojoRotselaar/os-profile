class profile::keyboard (
  Optional[String] $layout = 'us',
) {
  $keyboard_config = {
    'XKBLAYOUT' => $layout,
    'BACKSPACE' => 'guess',
  }

  $keyboard_config_settings = {
    'quote_char' => '',
  }

  file { '/etc/default/keyboard':
    ensure  => present,
    content => hash2kv($keyboard_config, $keyboard_config_settings),
  }
}
