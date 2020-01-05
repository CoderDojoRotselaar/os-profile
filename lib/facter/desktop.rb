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
