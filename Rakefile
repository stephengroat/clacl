require 'resolv'
require 'rubocop/rake_task'
require 'open-uri'
require 'json'
require 'nokogiri'

task default: %w[collect rubocop]

namespace :collect do
  task :gcp do
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

  task :cloudflare do
    %w[4 6].each do |ver|
      puts "Running IPv#{ver}"
      list = open("https://www.cloudflare.com/ips-v#{ver}")
      list.each do |ip|
        puts ip
      end
    end
  end

  task :aws, %i[region service] do |_t, args|
    args.with_defaults(region: '.*', service: '.*')

    list = open('https://ip-ranges.amazonaws.com/ip-ranges.json')
    data_hash = JSON.parse(list.read)
    data_hash['prefixes'].each do |prefix|
      puts prefix['ip_prefix'] if prefix['region'] =~ /#{args[:region]}/ && \
                                  prefix['service'] =~ /#{args[:service]}/
    end
  end

  task :salesforce do
    page = Nokogiri::HTML(open('https://help.salesforce.com/articleView?id=000003652&type=1'))   
    puts page.class
  end
end

task :collect do
  Rake.application.in_namespace(:collect).tasks do |task|
    puts task
    Rake.application.invoke(task)
  end
end

RuboCop::RakeTask.new
