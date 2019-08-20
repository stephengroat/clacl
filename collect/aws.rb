# frozen_string_literal: true

require 'open-uri'
require 'json'

namespace :collect do
  task :aws, %i[region service] do |_t, args|
    args.with_defaults(region: '.*', service: '.*')

    list = open('https://ip-ranges.amazonaws.com/ip-ranges.json')
    data_hash = JSON.parse(list.read)
    data_hash['prefixes'].each do |prefix|
      puts prefix['ip_prefix'] if prefix['region'] =~ /#{args[:region]}/ && \
                                  prefix['service'] =~ /#{args[:service]}/
    end
  end
end
