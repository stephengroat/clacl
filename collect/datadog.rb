require 'open-uri'
require 'json'

namespace :collect do
  task :datadog do |_t, _args|
    list = open('https://ip-ranges.datadoghq.com/')
    data_hash = JSON.parse(list.read)
    %w[agents api apm logs process webhooks].each do |service|
      puts data_hash[service]['prefixes_ipv4']
      puts data_hash[service]['prefixes_ipv6']
    end
  end
end
