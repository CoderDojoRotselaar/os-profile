define profile::network (
  Enum['ethernet', 'wifi', 'vpn'] $type,
  Optional[String] $username            = undef,
  Optional[Sensitive[String]] $password = undef,
  String $con_name                      = $name,
  String $ifname                        = '*',
  String $ssid                          = $name,
  Optional[String] $vpn_type            = undef,
  Hash[String, Any] $extra_params       = {},
) {
  if $username {
    $dot1x_params = {
      '802-1x.identity'     => $username,
      '802-1x.phase2-auth'  => 'mschapv2',
      '802-1x.eap'          => 'peap',
      '802-1x.auth-timeout' => 5,
      '802-1x.ca-cert'      => '/etc/ssl/certs/ca-bundle.crt',
    }
  } else {
    $dot1x_params = {}
  }

  $command_params = {
    'type'     => $type,
    'con-name' => $con_name,
    'ifname'   => $ifname,
  }
  $type_params = $type ? {
    'wifi'  => { 'ssid' => $ssid },
    'vpn'   => { 'vpn-type' => $vpn_type },
    default => {},
  }

  $merged_command_params = merge($command_params, $type_params)

  $add_command_params = $merged_command_params.reduce('') |String $memo, Array $pair| {
    $new = "${pair[0]} '${pair[1]}'"
    "${memo} ${new}"
  }

  $merged_params = merge($dot1x_params, $extra_params)
  $escaped_params = $merged_params.reduce('') |String $memo, Array $pair| {
    $new = "${pair[0]} '${pair[1]}'"
    "${memo} ${new}"
  }

  $command = "/usr/bin/nmcli con add ${add_command_params} -- ${escaped_params}"

  exec { "Create wired network '${con_name}'":
    command => $command,
    unless  => "/usr/bin/nmcli con show '${con_name}'"
  }

  if $password and $password != topsecret {
    $unwrapped_password = $password.unwrap

    if $username {
      $auth_command = "/usr/bin/nmcli con modify '${con_name}' 802-1x.password '${unwrapped_password}'"
    } else {
      $auth_command = "/usr/bin/nmcli con modify '${con_name}' wifi-sec.key-mgmt wpa-psk wifi-sec.psk '${unwrapped_password}'"
    }

    exec { "Authenticate to ${type} network '${con_name}'":
      command     => $auth_command,
      refreshonly => true,
      require     => Exec["Create wired network '${con_name}'"],
    }
  }
}

