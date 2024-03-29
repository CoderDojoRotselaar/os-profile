class profile {
  include ::profile::grub
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
  include ::profile::tilix
  include ::profile::codium
  include ::profile::firefox
  include ::profile::chromium
  include ::profile::upgrade
  include ::profile::git
  include ::profile::ruby
  include ::profile::python
  include ::profile::snaps
  include ::profile::secrets
  include ::profile::networks
  include ::profile::ssh_keys
  include ::profile::syncthing
  include ::profile::tidy
  include ::profile::mlink
  include ::profile::info

  case $facts['os']['family'] {
    'RedHat': { include profile::redhat }
    'Debian': { include profile::debian }
    default:  {} # do nothing
  }

  package { 'cloud-init':
    ensure => absent,
  }
}
