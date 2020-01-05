class profile::upgrade::redhat (
  Enum['default', 'security'] $upgrade_type = 'default',
  Enum['yes', 'no'] $apply_updates = 'yes',
) {
  $unquoted_ini = {
    'quote_char' => '',
  }

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

  package { 'dnf-automatic':
    ensure => present,
  }

  file { '/etc/dnf/automatic.conf':
    ensure  => present,
    content => hash2ini($upgrade_config, $unquoted_ini),
    before  => Service['dnf-automatic.timer'],
  }

  service { 'dnf-automatic.timer':
    ensure  => running,
    enable  => true,
    require => Package['dnf-automatic'],
  }
}
