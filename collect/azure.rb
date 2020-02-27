# frozen_string_literal: true

require 'webdrivers'
require 'xmlsimple'

namespace :collect do
  task :azure, %i[region] do |_t, args|
    list = nil
    args.with_defaults(region: '.*')

    Dir.mktmpdir do |dir|
      options = Selenium::WebDriver::Chrome::Options.new(args: ['no-sandbox'])

      prefs = {
        prompt_for_download: false,
        default_directory: dir.to_s
      }
      options.add_preference(:download, prefs)
      options.add_preference("savefile.default_directory": dir.to_s)

      driver = Selenium::WebDriver.for(:chrome, options: options)

      driver.get('https://www.microsoft.com/en-us/download/confirmation.aspx?id=41653')
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
