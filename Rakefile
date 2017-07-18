task default: %w[collect]

task :collect do
  Resolv::DNS.open do |dns|
    ress = dns.getresources "_cloud-netblocks.googleusercontent.com", Resolv::DNS::Resource::IN::TXT
    ress.data.scan(/(?<=include:)_cloud-netblocks[0-9].googleusercontent.com/).each do |r|
      subress = dns.getresources r, , Resolv::DNS::Resource::IN::TXT
      puts subress.data
    end
  end
end
