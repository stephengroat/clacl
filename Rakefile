require "resolv"
require "rubocop/rake_task"
require "open-uri"
require "json"
require "nokogiri"

task default: %w[collect rubocop]

namespace :collect do
  task :cloudflare do
    %w[4 6].each do |ver|
      puts "Running IPv#{ver}"
      list = open("https://www.cloudflare.com/ips-v#{ver}")
      list.each do |ip|
        puts ip
      end
    end
  end

  task :aws, %i[region service] do |_t, args|
    args.with_defaults(region: ".*", service: ".*")

    list = open("https://ip-ranges.amazonaws.com/ip-ranges.json")
    data_hash = JSON.parse(list.read)
    data_hash["prefixes"].each do |prefix|
      puts prefix["ip_prefix"] if prefix["region"] =~ /#{args[:region]}/ && \
                                  prefix["service"] =~ /#{args[:service]}/
    end
  end

  task :salesforce do
    page = Nokogiri::HTML(open("https://help.salesforce.com/articleView?id=000003652&type=1"))
    puts page.xpath("//table")
    puts page.xpath("//table").each do |node|
      puts node.txt
    end
    puts page.xpath("//table").length
  end
end

task :collect do
  Rake.application.in_namespace("collect") do |namespace|
    namespace.tasks.each do |task|
      puts "Running #{task}"
      Rake.application.invoke_task(task)
    end
  end
end

RuboCop::RakeTask.new
