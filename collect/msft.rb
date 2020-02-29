# frozen_string_literal: true

require 'selenium-webdriver'
require 'csv'

namespace :collect do
  task :msft do |_t, _args|
    list = nil

    Dir.mktmpdir do |dir|
      options = Selenium::WebDriver::Chrome::Options.new(args: ['no-sandbox'])

      prefs = {
        prompt_for_download: false,
        default_directory: dir.to_s
      }
      options.add_preference(:download, prefs)

      driver = Selenium::WebDriver.for(:chrome, options: options)

      driver.get('https://www.microsoft.com/en-us/download/confirmation.aspx?id=53602')

      loop do
        if Dir.glob("#{dir}/*.csv.part").any?
          sleep(10)
        elsif Dir.glob("#{dir}/*.csv").any?
          break
        else
          sleep(10)
        end
      end

      list = File.open(Dir.glob("#{dir}/*.csv")[0])
      driver.quit
    end

    # Get array of arrays from CSV
    data_hash = CSV.parse(list)
    # Use first title row as keys for Hashmap
    keys = data_hash.shift
    data_hash.map! { |a| Hash[keys.zip(a)] }
    data_hash.each do |prefix|
      puts prefix['Prefix']
    end
  end
end
