class profile::tidy {
  tidy { 'prune_old_crashes':
    path    => '/var/cache',
    recurse => 1,
  }
}
