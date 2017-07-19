require 'resolv'
require 'rubocop/rake_task'
require 'open-uri'
require 'json'

task default: %w[collect_gcp collect_cloudflare rubocop]

task :collect_gcp do
  puts 'Running collect_gcp'
  Resolv::DNS.open do |dns|
    gcp = '_cloud-netblocks.googleusercontent.com'
    ress = dns.getresource gcp, Resolv::DNS::Resource::IN::TXT
    gcp_regex = /(?<=include:)_cloud-netblocks+\d.googleusercontent.com/
    ress.data.scan(gcp_regex).each do |r|
      puts "Running TXT query on #{r}"
      subress = dns.getresource r, Resolv::DNS::Resource::IN::TXT
      subress.data.scan(/(?<=ip[4|6]:)[^\s]+/).each do |sr|
        puts sr
      end
    end
  end
end

task :collect_cloudflare do
  puts 'Running collect_cloudflare'
  %w[4 6].each do |ver|
    puts "Running IPv#{ver}"
    list = open("https://www.cloudflare.com/ips-v#{ver}")
    list.each do |ip|
      puts ip
    end
  end
end

task :collect_aws do
  puts 'Running collect_aws'
  list = open('https://ip-ranges.amazonaws.com/ip-ranges.json')
  data_hash = JSON.parse(list)
  data_hash['prefixes'].each do |prefix|
    puts prefix['ip_prefix']
  end
end

RuboCop::RakeTask.new
