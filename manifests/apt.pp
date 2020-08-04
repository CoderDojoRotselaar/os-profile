class profile::apt {
  $apt_custom_options = [
    'Acquire::Retries "5";',
    'Acquire::Queue-Mode "access";',
  ]

  $apt_custom_options_string = join($apt_custom_options, "\n")

  apt::conf { 'custom':
    priority => 80,
    tag      => 'early',
    content  => "${apt_custom_options_string}\n",
  }

  if ! $facts['deploy'] {
    file { '/etc/apt/apt.conf':
      content => '',
    }
  }
}
