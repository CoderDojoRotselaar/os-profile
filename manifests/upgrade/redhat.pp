class profile::upgrade::redhat (
  Enum['default', 'security'] $upgrade_type = 'default',
  Enum['yes', 'no'] $apply_updates = 'yes',
) {
  $upgrade_config = {
    'commands' => {
      'upgrade_type'     => $upgrade_type,
      'random_sleep'     => 0,
      'download_updates' => 'yes',
      'apply_updates'    => $apply_updates,
    },
    'emitters' => {
      'emit_via' => 'stdio',
    },
    'base'     => {
      'debuglevel' => 1,
    },
  }

  $dnf_automatic_override = {
    'Timer' => {
      'Calendar'           => '*-*-* *:00',
      'RandomizedDelaySec' => '10m',
    },
  }

  package { 'dnf-automatic':
    ensure => present,
  }

  file {
    '/etc/dnf/automatic.conf':
      ensure  => present,
      content => hash2ini($upgrade_config),
      before  => Service['dnf-automatic.timer'],
      ;
    '/etc/systemd/system/dnf-automatic.timer.d/':
      ensure  => directory,
      mode    => '0755',
      ;
    '/etc/systemd/system/dnf-automatic.timer.d/override.conf':
      ensure  => present,
      content => hash2ini($dnf_automatic_override),
      notify  => [
        Class['profile::systemd'],
        Service['dnf-automatic.timer'],
      ],
      ;
  }

  service { 'dnf-automatic.timer':
    ensure  => running,
    enable  => true,
    require => Package['dnf-automatic'],
  }
}
