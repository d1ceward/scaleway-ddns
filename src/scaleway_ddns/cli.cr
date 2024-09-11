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
    def initialize : Nil
      parser = option_parser
      parser.parse

      # If run_updater flag is set, start the updater; otherwise, display help.
      run_updater? ? updater_start : display_help(parser, 1)
    end

    # Starts the updater process.
    private def updater_start : Nil
      Process.on_terminate do |reason|
        next unless reason.aborted? || reason.interrupted? || reason.session_ended?

        STDOUT.puts("terminating gracefully...")
        exit(0)
      end

      ScalewayDDNS::Updater.new(config).run
    end

    # Print the version number to the standard output and exits the program.
    private def display_version : Nil
      STDOUT.puts "version #{ScalewayDDNS::VERSION}"
      exit
    end

    # Print the help message to the standard output for the CLI.
    private def display_help(parser : OptionParser, exit_code : Int32 = 0) : Nil
      STDOUT.puts(parser)
      exit(exit_code)
    end

    # This method is used to handle missing options in the command line interface.
    private def missing_option(parser : OptionParser, flag : String) : Nil
      STDERR.puts("ERROR: #{flag} is missing something.")
      STDERR.puts(parser)
      exit(1)
    end

    # This method is used to handle invalid options in the command line arguments.
    private def invalid_option(parser : OptionParser, flag : String) : Nil
      STDERR.puts("ERROR: #{flag} is not a valid option.")
      STDERR.puts(parser)
      exit(1)
    end

    # This method returns an OptionParser object that is used to define and parse command line options.
    # The options include running the DNS update, displaying the version, and showing help.
    # If an invalid or missing option is encountered, appropriate error messages are displayed.
    private def option_parser : OptionParser
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
