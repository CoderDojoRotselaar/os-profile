class profile::tidy {
  tidy { 'prune_old_crashes':
    path    => '/var/crash',
    recurse => 1,
  }
}
