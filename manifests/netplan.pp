class profile::netplan {
  $interfaces = $facts['networking']['interfaces']

  $ethernet_configs = $interfaces.reduce({}) |$collection, $if| {
    $ifname = $if[0]
    $ifconfig = $if[1]

    if $ifname =~ /^enp/ {
      $result = $collection.merge(
        {
          $ifname => {
            'dhcp4'    => 'yes',
            'optional' => true,
          },
        }
      )
    } else {
      $result = $collection
    }
    $result
  }

  $settings = {
    'header' => '# THIS FILE IS CONTROLLED BY PUPPET',
  }
  $config = {
    'network' => {
      'version'   => 2,
      'renderer'   => 'networkd',
      'ethernets' => $ethernet_configs,
    }
  }

  file { '/etc/netplan/01-netcfg.yaml':
    ensure  => file,
    content => hash2yaml($config, $settings),
    require => Class[profile::networks],
  }

  if ! $facts['deploy'] {
    exec { 'apply netplan':
      command     => '/usr/sbin/netplan apply',
      subscribe   => File['/etc/netplan/01-netcfg.yaml'],
      refreshonly => true,
    }
  }

  cron { 'restart network after boot':
    ensure  => present,
    command => '( /usr/bin/killall /sbin/wpa_supplicant && /usr/bin/systemctl restart NetworkManager ) &>/tmp/fix-network',
    user    => 'root',
    special => 'reboot',
  }
}
