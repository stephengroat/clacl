task default: %w[collect]

task :collect do
  Resolv::DNS.open do |dns|
    ress = dns.getresource "_cloud-netblocks.googleusercontent.com", Resolv::DNS::Resource::IN::TXT
    ress.data.scan(/(?<=include:)_cloud-netblocks+\d.googleusercontent.com/).each do |r|
      subress = dns.getresource r, Resolv::DNS::Resource::IN::TXT
      puts subress.data
    end
  end
end
