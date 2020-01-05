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

  package { 'dnf-automatic':
    ensure => present,
  }

  $upgrade_defaults = {
    path => '/etc/dnf/automatic.conf',
  }

  create_ini_settings($upgrade_config, $upgrade_defaults)

  file { '/etc/systemd/system/dnf-automatic.timer.d/':
    ensure => directory,
    mode   => '0755',
  }

  ini_setting { 'dnf automatic timer setting':
    ensure  => present,
    path    => '/etc/systemd/system/dnf-automatic.timer.d/override.conf',
    section => 'Timer',
    setting => 'OnUnitInactiveSec',
    value   => '8h',
  }
}
