require 'rubocop/rake_task'
require 'open-uri'
require 'nokogiri'
Dir.glob('collect/*.rb').each { |r| import r }

task default: %w[collect rubocop]

namespace :collect do
  task :salesforce do
    page = Nokogiri::HTML(open('https://help.salesforce.com/articleView?id=000003652&type=1'))
    puts page.xpath('//table')
    puts page.xpath('//table').each do |node|
      puts node.txt
    end
    puts page.xpath('//table').length
  end
end

namespace :collect do
  task :oraclecloud do
    page = Nokogiri::HTML(open('https://docs.us-phoenix-1.oraclecloud.com/Content/Network/Concepts/overview.htm#oci-public-ips'))
    puts page.xpath('//table')
    puts page.xpath('//table').each do |node|
      puts node.txt
    end
    puts page.xpath('//table').length
  end
end

# namespace :collect do
#  task :ibmbluemix do
#    page = Nokogiri::HTML(
#                          open('https://knowledgelayer.softlayer.com/faq/what-ip-ranges-do-i-allow-through-firewall'))
#  end
# end

# rubocop:disable Metrics/BlockLength
namespace :collect do
  task :tableau do
    page = Nokogiri::HTML(open('https://onlinehelp.tableau.com/current/online/en-us/to_keep_data_fresh.htm'))

    # get table headers
    tables = []
    headers = []
    page.xpath('//*/table/thead/tr/th').each do |th|
      headers << th.text
      if th.next_element.nil?
        tables.push(headers)
        headers = []
      end
    end

    # get table rows
    rows = []
    tables_pos = 0
    page.xpath('//*/table/tbody/tr').each_with_index do |row, i|
      rows[i] = {}
      row.xpath('td').each_with_index do |td, j|
        rows[i][tables[tables_pos][j]] = td.text.to_s
      end
      next unless row.next_element.nil?

      tables[tables_pos].push(rows.reject(&:nil?))
      tables_pos += 1
      rows = []
    end
    tables[1][3].each do |element|
      p element['IP Address or Range'].strip.gsub(/\s+/, ',')
    end
  end
end
# rubocop:enable Metrics/BlockLength

task :collect do
  Rake.application.in_namespace('collect') do |namespace|
    namespace.tasks.each do |task|
      puts "Running #{task}"
      Rake.application.invoke_task(task)
    end
  end
end

RuboCop::RakeTask.new
