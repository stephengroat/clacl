require 'xmlsimple'
require 'pry'
require 'uri'

namespace :collect do
  task :automattic do |_t, _args|
    list = URI.open('http://whois.arin.net/rest/org/AUTOM-93/nets')
    # Convert XML to Hash
    data_hash = XmlSimple.xml_in(list)
    data_hash['netRef'].each do |netref|
      cidr = XmlSimple.xml_in(URI.open(netref['content']))
      start_address = cidr['netBlocks'][0]['netBlock'][0]['startAddress'][0]
      cidr_length = cidr['netBlocks'][0]['netBlock'][0]['cidrLength'][0]
      puts start_address + '/' + cidr_length
    end
  end
end
