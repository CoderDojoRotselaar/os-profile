require 'shellwords'

supported_desktop_sessions = [
  'lubuntu-desktop',
  'gnome-shell',
  'lightdm',
]

Facter.add('desktop_sessions') do
  setcode do
    case Facter.value(:os)['family']
    when 'RedHat'
      supported_desktop_sessions.reject do |ds|
        Facter::Core::Execution.execute('rpm -q ' + Shellwords.escape(ds)).match(%r{ not installed$})
      end
    when 'Debian'
      supported_desktop_sessions.select do |ds|
        Facter::Core::Execution.execute('dpkg -l ' + Shellwords.escape(ds)).match(%r{^ii})
      end
    else
      []
    end
  end
end

Facter.add('gdm_custom_conf_file') do
  setcode do
    [
      '/etc/gdm/custom.conf',
      '/etc/gdm3/custom.conf',
    ].find do |file|
      File.exist?(file)
    end
  end
end
