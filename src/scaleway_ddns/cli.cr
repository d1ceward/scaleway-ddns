module ScalewayDDNS
  class CLI
    property config : Config = Config.new
    property run_server : Bool = false

    def initialize
      parser = option_parser
      parser.parse

      @run_server ? ScalewayDDNS::Updater.new(config).run : display_help(parser, 1)
    end

    private def display_version
      STDOUT.puts "version #{ScalewayDDNS::VERSION}"
      exit
    end

    private def display_help(parser : OptionParser, exit_code : Int32 = 0)
      STDOUT.puts(parser)
      exit(exit_code)
    end

    private def missing_option(parser : OptionParser, flag : String)
      STDERR.puts("ERROR: #{flag} is missing something.")
      STDERR.puts("")
      STDERR.puts(parser)
      exit(1)
    end

    private def invalid_option(parser : OptionParser, flag : String)
      STDERR.puts("ERROR: #{flag} is not a valid option.")
      STDERR.puts(parser)
      exit(1)
    end

    private def option_parser
      OptionParser.new do |parser|
        parser.banner = "Prometheus Exporter for Shelly plugs\nUsage: shellyplug-exporter [subcommand]"
        parser.on("run", "Run exporter server") { @run_server = true }
        parser.on("-v", "--version", "Show version") { display_version }
        parser.on("-h", "--help", "Show help") { display_help(parser) }
        parser.missing_option { |flag| missing_option(parser, flag) }
        parser.invalid_option { |flag| invalid_option(parser, flag) }
      end
    end
  end
end
