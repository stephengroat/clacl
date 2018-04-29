require 'open-uri'

namespace :collect do
  task :cachefly do
    list = open('https://admin.cachefly.com/ips/rproxy.txt')
    list.each do |ip|
      puts ip
    end
  end
end
