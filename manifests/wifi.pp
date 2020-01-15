class profile::wifi {
  $networks = lookup('wifinetworks', Hash[String, Hash], 'hash', {})

  $networks.each |$net, $config| {
    profile::network { $config['ssid']:
      type     => 'wifi',
      password => Sensitive($config['password']),
    }
  }
}
