require 'resolv'

namespace :collect do
  task :travisci do |_t|
    # comes from https://docs.travis-ci.com/user/ip-addresses/
    addresses = Resolv.getaddresses('nat.travisci.net')
    addresses.each do |address|
      puts address + '/32'
    end
  end
end
