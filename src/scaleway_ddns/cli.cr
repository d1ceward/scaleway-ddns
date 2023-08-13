module ScalewayDDNS
  # CLI class handles command line interface interactions for the updater.
  #
  # ```
  # ScalewayDDNS::CLI.new
  # ```
  class CLI
    # Configuration settings for the updater.
    property config : Config = Config.new

    # Whether to run the updater.
    property? run_updater : Bool = false

    # Initialize the CLI.
    def initialize
      parser = option_parser
      parser.parse

      # If run_updater flag is set, start the updater; otherwise, display help.
      run_updater? ? ScalewayDDNS::Updater.new(config).run : display_help(parser, 1)
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
        parser.banner = "Simple Scaleway dynamic DNS service by API\nUsage: scaleway-ddns [subcommand]"
        parser.on("run", "Run DNS update") { self.run_updater = true }
        parser.on("-v", "--version", "Show version") { display_version }
        parser.on("-h", "--help", "Show help") { display_help(parser) }
        parser.missing_option { |flag| missing_option(parser, flag) }
        parser.invalid_option { |flag| invalid_option(parser, flag) }
      end
    end
  end
end
