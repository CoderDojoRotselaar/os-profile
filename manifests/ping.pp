class profile::ping (
  Optional[String] $target = undef
) {
  if $target {
    $hostname = $facts['hostname']
    $ip = $facts['networking']['ip']

    exec { 'ping puppet run':
      command => "/usr/bin/curl '${target}?action=puppet&hostname=${hostname}&ip=${ip}'",
    }
  }
}
