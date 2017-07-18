task default: %w[collect]

task :collect do
  Resolv::DNS.open do |dns|
    ress = dns.getresources "_cloud-netblocks.googleusercontent.com", Resolv::DNS::Resource::IN::TXT
    ress.each do |r|
      puts r.data
    end
  end
end
