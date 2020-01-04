class profile::systemd {
  exec { '/bin/systemctl daemon-reload':
    refreshonly => true,
  }
}
