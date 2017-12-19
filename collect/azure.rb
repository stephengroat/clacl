require "open-uri"
require "xmlsimple"

namespace :collect do
  task :azure, %i[region] do |_t, args|
    args.with_defaults(region: ".*")

    list = open("https://download.microsoft.com/download/0/1/8/018E208D-54F8-44CD-AA26-CD7BC9524A8C/PublicIPs_20171215.xml")
    data_hash = XmlSimple.xml_in(list)
    data_hash["Region"].each do |prefix|
      if prefix["Name"] =~ /#{args[:region]}/
        prefix["IpRange"].each do |subnet|
          puts subnet["Subnet"]
	end
      end
    end
  end
end
