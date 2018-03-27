require "resolv"

namespace :collect do
  task :travisci  do |_t|
    addresses = Resolv.getaddresses("nat.travisci.net")
    addresses.each do |address|
      puts address + "/32"
    end
  end
end
