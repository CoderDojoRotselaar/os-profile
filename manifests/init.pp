class profile {
  include ::profile::packages
  include ::profile::systemd

  file {
    '/usr/lib/systemd/system/puppet-agent.timer':
      ensure  => present,
      content => file('profile/puppet-agent.timer'),
      notify  => Class['profile::systemd'],
      ;
    '/usr/lib/systemd/system/puppet-agent.service':
      ensure  => present,
      content => file('profile/puppet-agent.service'),
      notify  => Class['profile::systemd'],
      ;
  }
}
