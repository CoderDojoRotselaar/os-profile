class profile::upgrade::debian {
  class { 'unattended_upgrades':
    enable       => 1,
    random_sleep => 600,
    auto         => {
      clean => 1,
    }
  }

  file {
    '/etc/apt/apt.conf':
      ensure  => absent,
      ;
    '/etc/xdg/autostart/update-notifier.desktop':
      ensure  => absent,
      ;
  }

  Package <| |> -> File['/etc/apt/apt.conf']
}
