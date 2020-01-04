class profile {
  include ::profile::packages
  include ::profile::systemd
  include ::profile::puppetapply
}
