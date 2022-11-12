require "log"
require "yaml"
require "option_parser"
require "json"
require "http/client"

require "./version"
require "./scaleway_ddns/cli"
require "./scaleway_ddns/config"
require "./scaleway_ddns/errors"
require "./scaleway_ddns/ip"
require "./scaleway_ddns/request"
require "./scaleway_ddns/updater"

ScalewayDDNS::CLI.new unless ENV["CRYSTAL_SPEC_CONTEXT"]?
