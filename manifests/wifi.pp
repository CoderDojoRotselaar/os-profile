class profile::wifi {
  $networks = lookup('wifinetworks', Hash[String, Hash], 'hash', {})
  $wifi = $facts['wifi_device']
  if ($wifi) {
    exec { 'Configure wifi interfaces':
      command => "/usr/sbin/netplan set network.ethernets.${wifi}.dhcp4=true",
      unless  => "/usr/sbin/netplan get network.ethernets.${wifi}.dhcp4 | grep -qFx 'true'",
      notify  => Exec['apply netplan'],
    }

    $networks.each |$net, $config| {
      if ($facts['os']['release']['major'] == '20.04') {
        profile::network { $config['ssid']:
          type     => 'wifi',
          password => Sensitive($config['password']),
        }
      } else {
        $path = "network.wifis.${wifi}.access-points.'${net}'.auth"
        exec { "Configure WiFi for '${net}'.password":
          command => "/usr/sbin/netplan set ${path}.password='${config['password']}'",
          unless  => "/usr/sbin/netplan get ${path}.password | grep -qFx '\"${config['password']}\"'",
          notify  => Exec['apply netplan'],
        }
        exec { "Configure WiFi for '${net}'.key-management":
          command => "/usr/sbin/netplan set ${path}.key-management='psk'",
          unless  => "/usr/sbin/netplan get ${path}.key-management | grep -qFx '\"psk\"'",
          notify  => Exec['apply netplan'],
        }
      }
    }
  }
}
