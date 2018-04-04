require "open-uri"

namespace :collect do
  task :pingdom do
    %w[4 6].each do |ipver|
      list = open("https://my.pingdom.com/probes/ipv" + ipver)
      list.each do |ip|
        puts ip
      end
    end
  end
end
