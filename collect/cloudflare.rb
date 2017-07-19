require "open-uri"

namespace :collect do
  task :cloudflare do
    %w[4 6].each do |ver|
      puts "Running IPv#{ver}"
      list = open("https://www.cloudflare.com/ips-v#{ver}")
      list.each do |ip|
        puts ip
      end
    end
  end
end
