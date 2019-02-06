require 'open-uri'

namespace :collect do
  task :cachefly do
    # TODO: fix
    OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
    list = open('https://admin.cachefly.com/ips/rproxy.txt')
    list.each do |ip|
      puts ip
    end
  end
end
