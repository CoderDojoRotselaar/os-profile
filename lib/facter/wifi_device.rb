def find_wifi
  devices = %x(nmcli -t device).split("\n")
  devices.each do |dev|
    name, type, managed = dev.split(':')
    return name if type == 'wifi'
  end
end

Facter.add('wifi_device') do
  setcode do
    find_wifi
  end
end
