require 'selenium-webdriver'
require 'csv'

namespace :collect do
  task :msft do |_t, _args|
    list = nil

    options = Selenium::WebDriver::Chrome::Options.new(args: ['no-sandbox'])

    Dir.mktmpdir do |dir|
      prefs = {
        prompt_for_download: false,
        default_directory: dir.to_s
      }
      options.add_preference(:download, prefs)

      driver = Selenium::WebDriver.for(:chrome, options: options)

      driver.get('https://www.microsoft.com/en-us/download/confirmation.aspx?id=53602')
      list = File.open(Dir.glob("#{dir}/*.csv")[0])
      driver.quit
    end

    data_hash = CSV.parse(list)
    keys = data_hash.shift
    data_hash.map! { |a| Hash[keys.zip(a)] }
    data_hash.each do |prefix|
      puts prefix['Prefix']
    end
  end
end
