require "open-uri"
require "json"

namespace :collect do
  task :github  do |_t|
    list = open("https://api.github.com/meta", http_basic_authentication: [ENV["githubcom"].split(":")[0], ENV["githubcom"].split(":")[1]]) unless ENV["githubcom"].nil?
    list = open("https://api.github.com/meta") if ENV["githubcom"].nil?
    data_hash = JSON.parse(list.read)
    %w[hooks git pages importer].each do |type|
      data_hash[type].each do |address|
        puts address
      end
    end
  end
end
