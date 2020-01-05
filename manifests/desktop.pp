class profile::desktop {
  notify { "Desktop environments: ${facts['desktop_sessions']}": }
  $ds_classes = $facts['desktop_sessions'].map |String $ds| {
    $sanitized_ds = regsubst($version, /[^[:alnum:]+]/, '_', 'G')
    "profile::desktop::${sanitized_ds}"
  }

  include $ds_classes
}
