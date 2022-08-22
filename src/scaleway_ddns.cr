require "log"
require "yaml"
require "option_parser"
require "json"
require "http/client"

require "./version"
require "./scaleway_ddns/config"
require "./scaleway_ddns/errors"
require "./scaleway_ddns/ip"
require "./scaleway_ddns/request"
require "./scaleway_ddns/updater"

run_updater = false

# Intialize CLI parser
option_parser = OptionParser.new do |parser|
  parser.banner = "Simple Scaleway dynamic DNS service by API\nUsage: scaleway-ddns [subcommand]"

  parser.on("run", "Run DNS update") do
    run_updater = true
  end

  parser.on("-v", "--version", "Show version") do
    puts "version #{ScalewayDDNS::VERSION}"
    exit
  end

  parser.on("-h", "--help", "Show help") do
    puts parser
    exit
  end

  parser.missing_option do |option_flag|
    STDERR.puts "ERROR: #{option_flag} is missing something."
    STDERR.puts ""
    STDERR.puts parser
    exit(1)
  end

  parser.invalid_option do |flag|
    STDERR.puts "ERROR: #{flag} is not a valid option."
    STDERR.puts parser
    exit(1)
  end
end

option_parser.parse

# Initialize default config
config = ScalewayDDNS::Config.new
updater = ScalewayDDNS::Updater.new(config)

# Run updater if run command is supplied or print help and exit
if run_updater
  updater.run
else
  puts option_parser
  exit(1)
end
