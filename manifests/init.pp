class profile {
  include ::profile::disks
  include ::profile::hostname
  include ::profile::ssh
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
  include ::profile::upgrade
  include ::profile::git
  include ::profile::ruby
  include ::profile::python
  include ::profile::secrets
  include ::profile::wifi
  include ::profile::ssh_keys

  case $facts['os']['family'] {
    'RedHat': { include profile::redhat  }
    'Debian': { include profile::debian  }
    default:  { } # do nothing
  }
}
