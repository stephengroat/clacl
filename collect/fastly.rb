require 'open-uri'
require 'json'

namespace :collect do
  task :fastly do
    list = open('https://api.fastly.com/public-ip-list')
    data_hash = JSON.parse(list.read)
    data_hash['addresses'].each do |address|
      puts address
    end
  end
end
