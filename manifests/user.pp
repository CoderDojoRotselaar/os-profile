class profile::user (
  String $coderdojo_user               = 'coderdojo',
  String $coderdojo_group              = $coderdojo_user,
  String $coderdojo_password           = '$6$XTj1xyhI$Ku8xdtmejyS0h/1wBIcLt8LBPoV2n7UBzKM7cCrQyd3CEyd.NeRrldfL05SHaQVGkgSopvDVt8fRX/6mbzuPL/',
  Stdlib::AbsolutePath $coderdojo_home = "/home/${coderdojo_user}",
) {
  $groups = $facts['os']['family'] ? {
    'Debian' => ['adm', 'cdrom', 'sudo', 'dip', 'plugdev', 'lpadmin', 'sambashare'],
    'RedHat' => ['wheel'],
    default  => [],
  }

  group { $coderdojo_group:
    ensure => present,
    gid    => 1000,
  }

  user { $coderdojo_user:
    ensure         => present,
    shell          => '/bin/bash',
    comment        => 'CoderDojo',
    password       => Sensitive($coderdojo_password),
    home           => $coderdojo_home,
    uid            => 1000,
    gid            => 1000,
    groups         => $groups,
    membership     => 'minimum',
    managehome     => true,
    purge_ssh_keys => true,
  }

  exec { "update ${coderdojo_user} user-dirs":
    command     => '/usr/bin/xdg-user-dirs-update --force',
    refreshonly => true,
    subscribe   => User[$coderdojo_user],
    user        => $coderdojo_user,
  }

  user { 'root':
    ensure         => present,
    shell          => '/bin/bash',
    password       => 'x',
    home           => '/root',
    uid            => 0,
    gid            => 0,
    groups         => ['root'],
    membership     => 'inclusive',
    managehome     => true,
    purge_ssh_keys => true,
  }

  file { "${coderdojo_home}/.config/autostart/lite-welcome.desktop":
    ensure => absent,
  }
}
