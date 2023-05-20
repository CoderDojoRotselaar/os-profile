Facter.add('wifi_device') do
  setcode do
    devices = %x(nmcli -t device).split("\n")
    wifi = devices.find do |dev|
      name, type, managed = dev.split(':')
      name if type == 'wifi'
    end

    wifi
  end
end
