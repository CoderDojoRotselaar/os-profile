class profile::user (
  String $coderdojo_password = '$6$XTj1xyhI$Ku8xdtmejyS0h/1wBIcLt8LBPoV2n7UBzKM7cCrQyd3CEyd.NeRrldfL05SHaQVGkgSopvDVt8fRX/6mbzuPL/',
) {
  $groups = $facts['os']['family'] ? {
    'Debian' => ['adm', 'cdrom', 'sudo', 'dip', 'plugdev', 'lpadmin', 'sambashare'],
    'RedHat' => ['wheel'],
    default  => [],
  }

  group { 'coderdojo':
    ensure => present,
    gid    => 1000,
  }

  user { 'coderdojo':
    ensure   => present,
    password => Sensitive($coderdojo_password),
    home     => '/home/coderdojo',
    uid      => 1000,
    gid      => 1000,
    groups   => $groups,
  }



}
