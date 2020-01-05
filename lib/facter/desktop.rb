supported_desktop_sessions = [
  'gnome-shell',
  'lightdm',
]

Facter.add('desktop_sessions') do
  confine Facter.value(:os)['family'] => 'RedHat'
  setcode do
    supported_desktop_sessions.select do |ds|
      Facter::Core::Execution.execute('rpm -q ' + Shellwords.escape(ds), on_fail: false)
    end
  end
end

Facter.add('desktop_sessions') do
  confine Facter.value(:os)['family'] => 'Debian'
  setcode do
    supported_desktop_sessions.select do |ds|
      Facter::Core::Execution.execute('dpkg -l ' + ds + ' | grep "^ii"', on_fail: false)
    end
  end
end
