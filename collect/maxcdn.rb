# frozen_string_literal: true

require 'open-uri'

namespace :collect do
  task :maxcdn do
    list = open('https://support.maxcdn.com/hc/en-us/article_attachments/360051920551/maxcdn_ips.txt')
    list.each do |ip|
      puts ip
    end
  end
end
