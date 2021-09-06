class profile::time {
  class { 'ntp': }

  class { 'timezone':
    timezone => 'Europe/Brussels',
  }
}
