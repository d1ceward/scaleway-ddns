require "log"
require "yaml"
require "option_parser"
require "json"
require "http/client"

require "./version"
require "./scaleway_ddns/config"
require "./scaleway_ddns/updater"
require "./scaleway_ddns/request"

# Initialize default config
config = ScalewayDDNS::Config.new
ScalewayDDNS::Updater.new(config).perform

# # Intialize CLI parser
# option_parser = OptionParser.new do |parser|
#   parser.banner = "Scaleway dynamic DNS service by API\nUsage: scaleway-ddns [subcommand]"

#   parser.on("-v", "--version", "Show version") do
#     puts "version #{ScalewayDDNS::VERSION}"
#     exit
#   end

#   parser.on("-h", "--help", "Show help") do
#     puts parser
#     exit
#   end

#   parser.missing_option do |option_flag|
#     STDERR.puts "ERROR: #{option_flag} is missing something."
#     STDERR.puts ""
#     STDERR.puts parser
#     exit(1)
#   end

#   parser.invalid_option do |flag|
#     STDERR.puts "ERROR: #{flag} is not a valid option."
#     STDERR.puts parser
#     exit(1)
#   end
# end

# option_parser.parse

# puts option_parser
# exit(1)
