class profile {
  include ::profile::time
  include ::profile::keyboard
  include ::profile::locale
  include ::profile::packages
  include ::profile::systemd
  include ::profile::puppetapply
  include ::profile::user
  include ::profile::desktop
  include ::profile::scratux
  include ::profile::upgrade
  include ::profile::git
}
