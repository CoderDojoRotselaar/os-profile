class profile::wifi {
  $networks = lookup('wifinetworks', Hash[String, Hash], 'hash', {})
  $wifi = $facts['wifi_device']
  if ($wifi) {
    exec { 'Configure wifi interfaces':
      command => "/usr/sbin/netplan set network.wifis.${wifi}.dhcp4=true",
      unless  => "/usr/sbin/netplan get network.wifis.${wifi}.dhcp4 | grep -qFx 'true'",
      notify  => Exec['apply netplan'],
    }

    $networks.each |$net, $config| {
      if ($facts['os']['release']['major'] == '20.04') {
        profile::network { $config['ssid']:
          type     => 'wifi',
          password => Sensitive($config['password']),
        }
      } else {
        $config = {
          'network': {
            'wifis': {
              $wifi: {
                'access-points': {
                  $net: {
                    'auth': {
                    'password': $config['password']},
                    'key-management': 'psk',
                  }
                }
              }
            }
          },
        }
        file { "/etc/netplan/wifi-${net}.yaml":
          ensure  => file,
          content => hash2yaml($config),
          notify  => Exec['apply netplan'],
        }
      }
    }
  }
}
