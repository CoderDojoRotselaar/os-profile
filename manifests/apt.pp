class profile::apt {
  $apt_custom_options = [
    'Acquire::Retries "5";',
    'Acquire::Queue-Mode "access";',
  ]

  $apt_custom_options_string = join($apt_custom_options, "\n")

  file { '/etc/apt/apt.conf.d/80-custom':
    ensure  => present,
    content => "${apt_custom_options_string}\n",
  }
}
