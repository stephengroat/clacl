# frozen_string_literal: true

require 'webdrivers'
require 'xmlsimple'

namespace :collect do
  task :azurepublic, %i[region] do |_t, args|
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

      driver.get('https://www.microsoft.com/en-us/download/confirmation.aspx?id=56519')

      while true
        if Dir.glob("#{dir}/*.xml.part").any?
            sleep(10)
        elsif Dir.glob("#{dir}/*.xml").any?
            break
        else
            sleep(10)
        end
      end

      list = File.open(Dir.glob("#{dir}/*.xml")[0])
      driver.quit
    end

    # Convert XML to Hash
    data_hash = XmlSimple.xml_in(list)
    data_hash['Region'].each do |prefix|
      next unless prefix['Name'] =~ /#{args[:region]}/
      next unless prefix.key?('IpRange')

      prefix['IpRange'].each do |subnet|
        puts subnet['Subnet']
      end
    end
  end
end
