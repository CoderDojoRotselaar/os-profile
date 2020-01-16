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

  $config = {
    'network' => {
      'version'   => 2,
      'rederer'   => 'networkd',
      'ethernets' => $ethernet_configs,
    }
  }

  file { '/tmp/netplan.yaml':
    ensure  => file,
    content => hash2yaml($config),
  }
}
