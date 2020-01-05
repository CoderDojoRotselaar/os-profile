require 'shellwords'

supported_desktop_sessions = [
  'gnome-shell',
  'lightdm',
]

Facter.add('desktop_sessions') do
  setcode do
    case Facter.value(:os)['family']
    when 'RedHat'
      supported_desktop_sessions.select do |ds|
        !Facter::Core::Execution.execute('rpm -q ' + Shellwords.escape(ds)).match(/ not installed$/)
      end
    when 'Debian'
      supported_desktop_sessions.select do |ds|
        Facter::Core::Execution.execute('dpkg -l ' + Shellwords.escape(ds)).match(/^ii/)
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
      if File.exist?(file)
        return file
      end
    end
    nil
  end
end
