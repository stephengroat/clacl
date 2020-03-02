# frozen_string_literal: true

require 'selenium-webdriver'
require 'csv'

namespace :collect do
  task :msft do |_t, _args|
    Dir.mktmpdir do |dir|
      options = Selenium::WebDriver::Chrome::Options.new

      options.add_preference(:download,
                             prompt_for_download: false,
                             directory_upgrade: true,
                             default_directory: dir.to_s)

      driver = Selenium::WebDriver.for(:chrome, options: options)

      driver.get('https://www.microsoft.com/en-us/download/confirmation.aspx?id=53602')

      loop do
        sleep(10) if Dir.glob("#{dir}/*.csv.part").any?
        break if Dir.glob("#{dir}/*.csv").any?
        sleep(10)
      end

      list = File.open(Dir.glob("#{dir}/*.csv")[0])

      # Get array of arrays from CSV
      data_hash = CSV.parse(list)
      # Use first title row as keys for Hashmap
      keys = data_hash.shift
      data_hash.map! { |a| Hash[keys.zip(a)] }
      data_hash.each do |prefix|
        puts prefix['Prefix']
      end
      driver.quit
    end
  end
end
