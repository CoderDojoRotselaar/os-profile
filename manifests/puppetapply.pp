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
    '/usr/sbin/puppet-apply':
      ensure => link,
      target => '/var/lib/puppet-deployment/puppet-apply.sh',
      ;
  }

  service {
    'puppet.service':
      ensure => stopped,
      enable => false,
      ;
    'puppet-apply.service':
      enable => true,
      ;
    'puppet-apply.timer':
      ensure => running,
      enable => true,
      ;
  }
}
