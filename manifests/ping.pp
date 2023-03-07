class profile::ping (
  Optional[String] $target = undef
) {
  if $target {
    $hostname = $facts['hostname']
    $ip = $facts['networking']['ip']
    $uuid = $facts['uuid']

    exec { 'ping puppet run':
      command => "/usr/bin/curl '${target}?action=puppet&uuid=${uuid}&hostname=${hostname}&ip=${ip}'",
    }
  }
}
