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

  apt::conf { 'curtin-aptproxy':
    ensure   => absent,
    priority => 90,
  }
  # Remove the proxy configuration after installing all packages (to maximize the proxy usage)
  Package <| |> -> Apt::Conf['curtin-aptproxy']

  apt::source { 'coderdojo':
    ensure         => present,
    tag            => 'early',
    location       => 'https://debrepo.dwarfy.be',
    allow_unsigned => true,
    repos          => 'binary/',
    release        => '',
  }
}
