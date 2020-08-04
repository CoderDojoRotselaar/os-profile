class profile::debian {
  include ::profile::netplan
  include ::profile::apt
}
