class profile {
  include ::profile::disks
  include ::profile::hostname
  include ::profile::ssh
  include ::profile::ping
  include ::profile::time
  include ::profile::keyboard
  include ::profile::locale
  include ::profile::packages
  include ::profile::systemd
  include ::profile::puppetapply
  include ::profile::user
  include ::profile::desktop
  include ::profile::scratux
  include ::profile::codium
  include ::profile::firefox
  include ::profile::chromium
  include ::profile::upgrade
  include ::profile::git
  include ::profile::ruby
  include ::profile::python
  include ::profile::snaps
  include ::profile::secrets
  include ::profile::wifi
  include ::profile::ssh_keys
  include ::profile::syncthing
  include ::profile::tidy
  include ::profile::mlink
  include ::profile::info

  case $facts['os']['family'] {
    'RedHat': { include profile::redhat  }
    'Debian': { include profile::debian  }
    default:  { } # do nothing
  }
}
