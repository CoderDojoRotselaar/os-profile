class profile::tilix {
  package { 'tilix':
    ensure   => installed,
  }

  file {'/etc/dconf/db/local.d/10-tilix':
    ensure  => present,
    content => file('profile/tilix.dconf'),
    notify  => Exec['dconf update'],
  }
}
