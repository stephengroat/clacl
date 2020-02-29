# frozen_string_literal: true

require 'webdrivers'
require 'json'

namespace :collect do
  task :azuregov, %i[region] do |_t, args|
    list = nil
    args.with_defaults(region: '.*')

    Dir.mktmpdir do |dir|
      options = Selenium::WebDriver::Chrome::Options.new(args: ['no-sandbox'])

      prefs = {
        prompt_for_download: false,
        default_directory: dir.to_s,
        directory_upgrade: true
      }
      options.add_preference(:download, prefs)
      prefs = {
        default_directory: dir.to_s
      }
      options.add_preference(:savefile, prefs)
      prefs = {
        enabled: false
      }
      options.add_preference(:safebrowsing, prefs)

      driver = Selenium::WebDriver.for(:chrome, options: options)

      driver.get('https://www.microsoft.com/en-us/download/confirmation.aspx?id=57063')

      loop do
        if Dir.glob("#{dir}/*.json.part").any?
          sleep(10)
        elsif Dir.glob("#{dir}/*.json").any?
          break
        else
          sleep(10)
        end
      end

      list = File.open(Dir.glob("#{dir}/*.json")[0])
      driver.quit
    end

    data_hash = JSON.parse(list.read)
    data_hash['values'].each do |value|
      value['properties']['addressPrefixes'].each do |addressPrefix|
        puts addressPrefix
      end
    end
  end
end
