Facter.add('uuid_lower') do
  setcode { (Facter.value('uuid') || '').downcase }
end
