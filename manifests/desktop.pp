class profile::desktop {
  notify { "Desktop environments: ${facts['desktop_sessions']}": }
  $facts['desktop_sessions'].each |String $ds| {
    include ::profile::desktop::$ds
  }
}
