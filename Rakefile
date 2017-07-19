require 'resolv'
require 'rubocop/rake_task'
require 'open-uri'

task default: %w[collect_gcp collect_cloudflare rubocop]

task :collect_gcp do
  Resolv::DNS.open do |dns|
    gcp = '_cloud-netblocks.googleusercontent.com'
    ress = dns.getresource gcp, Resolv::DNS::Resource::IN::TXT
    gcp_regex = /(?<=include:)_cloud-netblocks+\d.googleusercontent.com/
    ress.data.scan(gcp_regex).each do |r|
      subress = dns.getresource r, Resolv::DNS::Resource::IN::TXT
      subress.data.scan(/(?<=ip[4|6]:)[^\s]+/).each do |sr|
        puts sr
      end
    end
  end
end

task :collect_cloudflare do
  %w[4 6].each do |ver|
    list = open("https://www.cloudflare.com/ips-v#{ver}")
    list.each do |ip|
      puts ip
    end
  end
end

RuboCop::RakeTask.new
