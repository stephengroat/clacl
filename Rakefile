require 'resolv'
require 'rubocop/rake_task'

task default: %w[collect rubocop]

task :collect do
  Resolv::DNS.open do |dns|
    ress = dns.getresource "_cloud-netblocks.googleusercontent.com", Resolv::DNS::Resource::IN::TXT
    ress.data.scan(/(?<=include:)_cloud-netblocks+\d.googleusercontent.com/).each do |r|
      subress = dns.getresource r, Resolv::DNS::Resource::IN::TXT
      subress.data.scan(/(?<=ip[4|6]:)[^\s]+/).each do |sr|
        puts sr
      end
    end
  end
end

RuboCop::RakeTask.new
