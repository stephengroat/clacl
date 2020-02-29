# frozen_string_literal: true

require 'webdrivers'
require 'json'

namespace :collect do
  task :azure, %i[region] do |_t, args|
    [57_062, 57_064, 57_063, 56_519].each do |id|
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

        driver.get("https://www.microsoft.com/en-us/download/confirmation.aspx?id=#{id}")

        loop do
          if Dir.glob("#{dir}/*.json.part").any?
            sleep(1)
          elsif Dir.glob("#{dir}/*.json").any?
            break
          else
            sleep(1)
          end
        end

        list = File.open(Dir.glob("#{dir}/*.json")[0])
        driver.quit

        data_hash = JSON.parse(list.read)
        data_hash['values'].each do |value|
          value['properties']['addressPrefixes'].each do |address_prefix|
            puts address_prefix
          end
        end
      end
    end
  end
end
