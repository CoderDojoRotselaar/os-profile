class profile::puppetapply {
  file {
    '/lib/systemd/system/puppet-apply.timer':
      ensure  => present,
      content => file('profile/puppet-apply.timer'),
      notify  => [
        Class['profile::systemd'],
        Service['puppet-apply.timer'],
      ]
      ;
    '/lib/systemd/system/puppet-apply.service':
      ensure  => present,
      content => file('profile/puppet-apply.service'),
      notify  => [
        Class['profile::systemd'],
        Service['puppet-apply.timer'],
      ]
      ;
  }

  service { 'puppet-apply.timer':
    enable => true,
  }
}
