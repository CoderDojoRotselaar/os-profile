class profile::netplan {
  $interfaces = $facts['networking']['interfaces'].keys

  $interfaces.each |$ifname| {
    if $ifname =~ /^enp/ {
      exec { "Configure wired interface '${ifname}'.optional":
        command => "/usr/sbin/netplan set network.ethernets.${ifname}.optional=true",
        unless  => "/usr/sbin/netplan get network.ethernets.${ifname}.optional | grep -qFx 'true'",
        notify  => Exec['apply netplan'],
      }
      exec { "Configure wired interface '${ifname}'.dhcp4":
        command => "/usr/sbin/netplan set network.ethernets.${ifname}.dhcp4=true",
        unless  => "/usr/sbin/netplan get network.ethernets.${ifname}.dhcp4 | grep -qFx 'true'",
        notify  => Exec['apply netplan'],
      }
    }
  }

  if $facts['deploy'] {
    exec { 'apply netplan':
      command     => '/bin/true',
      refreshonly => true,
    }
  } else {
    exec { 'apply netplan':
      command     => '/usr/sbin/netplan apply',
      refreshonly => true,
    }
  }

  if ($facts['os']['release']['major'] == '20.04') {
    $restart_wpa = 'present'
  } else {
    $restart_wpa = 'absent'
  }

  cron { 'restart network after boot':
    ensure  => $restart_wpa,
    command => '( /usr/bin/killall /sbin/wpa_supplicant && /usr/bin/systemctl restart NetworkManager ) &>/tmp/fix-network',
    user    => 'root',
    special => 'reboot',
  }
}
