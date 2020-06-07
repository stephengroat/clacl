# frozen_string_literal: true

require 'open-uri'

namespace :collect do
  task :cachefly do
    list = open('https://cachefly.cachefly.net/ips/rproxy.txt')
    list.each do |ip|
      puts ip
    end
  end
end
