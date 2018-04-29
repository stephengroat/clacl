require 'selenium-webdriver'
require 'xmlsimple'

namespace :collect do
  task :azure, %i[region] do |_t, args|
    list = nil
    args.with_defaults(region: '.*')

    options = Selenium::WebDriver::Chrome::Options.new(args: ['no-sandbox'])

    Dir.mktmpdir do |dir|
      prefs = {
        prompt_for_download: false,
        default_directory: dir.to_s
      }
      options.add_preference(:download, prefs)

      driver = Selenium::WebDriver.for(:chrome, options: options)

      driver.get('https://www.microsoft.com/en-us/download/confirmation.aspx?id=41653')
      list = File.open(Dir.glob("#{dir}/*.xml")[0])
      driver.quit
    end

    data_hash = XmlSimple.xml_in(list)
    data_hash['Region'].each do |prefix|
      next unless prefix['Name'] =~ /#{args[:region]}/
      prefix['IpRange'].each do |subnet|
        puts subnet['Subnet']
      end
    end
  end
end
