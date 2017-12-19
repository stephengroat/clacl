require "open-uri"

namespace :collect do
  task :maxcdn do
    list = open("https://www.maxcdn.com/one/assets/ips.txt")
    list.each do |ip|
      puts ip
    end
  end
end
