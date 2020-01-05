class profile::desktop {
  notify { "Desktop environments: ${facts['desktop_sessions']}": }
  $ds_classes = $facts['desktop_sessions'].map |String $ds| {
    "profile::desktop::${ds}"
  }

  include $ds_classes
}
