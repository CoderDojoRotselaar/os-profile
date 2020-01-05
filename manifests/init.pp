class profile {
  include ::profile::time
  include ::profile::packages
  include ::profile::systemd
  include ::profile::puppetapply
  include ::profile::user
  include ::profile::desktop
  include ::profile::scratux
}
