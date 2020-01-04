class profile::puppetapply {
  file {
    '/lib/systemd/system/puppet-apply.timer':
      ensure  => present,
      content => file('profile/puppet-apply.timer'),
      notify  => [
        Class['profile::systemd'],
        Service['puppet-apply.service', 'puppet-apply.timer'],
      ]
      ;
    '/lib/systemd/system/puppet-apply.service':
      ensure  => present,
      content => file('profile/puppet-apply.service'),
      notify  => [
        Class['profile::systemd'],
        Service['puppet-apply.service', 'puppet-apply.timer'],
      ]
      ;
  }

  service {
    'puppet-apply.service':
      enable => true,
      ;
    'puppet-apply.timer':
      ensure => running,
      enable => true,
      ;
  }
}
