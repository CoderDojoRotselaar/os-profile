class profile {
  include ::profile::packages
  include ::profile::systemd

  file {
    '/usr/lib/systemd/system/puppet-apply.timer':
      ensure  => present,
      content => file('profile/puppet-apply.timer'),
      notify  => Class['profile::systemd'],
      ;
    '/usr/lib/systemd/system/puppet-apply.service':
      ensure  => present,
      content => file('profile/puppet-apply.service'),
      notify  => Class['profile::systemd'],
      ;
  }
}
