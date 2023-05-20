class profile::wifi {
  $networks = lookup('wifinetworks', Hash[String, Hash], 'hash', {})

  $networks.each |$net, $config| {
    if ($facts['os']['release']['major'] == '20.04') {
      profile::network { $config['ssid']:
        type     => 'wifi',
        password => Sensitive($config['password']),
      }
    } else {
      $wifi = $facts['wifi_device']

      if ($wifi) {
        $path = "network.wifis.${wifi}.access-points.'${net}'.auth.password"
        exec { "Configure WiFi for '${net}'":
          command => "/usr/sbin/netplan set ${path}='${config['password']}'",
          unless  => "/usr/sbin/netplan get ${path} | grep -q '${config['password']}'",
        }
      }
    }
  }
}
