class profile::time {
  class { 'ntp':
    service_enable => true,
  }
}
