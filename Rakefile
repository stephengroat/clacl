task default: %w[collect]

task :collect do
  Resolv::DNS.open do |dns|
    ress = dns.getresources "_cloud-netblocks.googleusercontent.com", Resolv::DNS::Resource::IN::TXT
    puts ress.map { |r| r.data }
  end
end
