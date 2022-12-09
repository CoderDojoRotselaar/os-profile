class profile::grub {
  class { 'grub2':
    cmdline_linux_default => 'quiet splash',
  }
}
