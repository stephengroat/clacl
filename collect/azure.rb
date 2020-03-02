# frozen_string_literal: true

require 'webdrivers'
require 'json'

MS_DOWNLOAD_URL = 'https://www.microsoft.com/en-us/download/confirmation.aspx?id='

namespace :collect do
  task :azure, %i[region] do |_t, args|
    [57_062, 57_064, 57_063, 56_519].each do |id|
      args.with_defaults(region: '.*')

      Dir.mktmpdir do |dir|
        options = Selenium::WebDriver::Chrome::Options.new

        options.add_preference(:download,
                               prompt_for_download: false,
                               directory_upgrade: true,
                               default_directory: dir.to_s)

        driver = Selenium::WebDriver.for(:chrome, options: options)

        driver.get(MS_DOWNLOAD_URL + id.to_s)

        loop do
          sleep(10) if Dir.glob("#{dir}/*.json.part").any?
          break if Dir.glob("#{dir}/*.json").any?
        end

        list = File.open(Dir.glob("#{dir}/*.json")[0])

        JSON.parse(list.read)['values'].each do |value|
          value['properties']['addressPrefixes'].each do |address_prefix|
            puts address_prefix
          end
        end
        driver.quit
      end
    end
  end
end
