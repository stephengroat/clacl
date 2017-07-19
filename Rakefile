require "rubocop/rake_task"
require "open-uri"
require "nokogiri"
Dir.glob("collect/*.rb").each { |r| import r }

task default: %w[collect rubocop]

namespace :collect do
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
