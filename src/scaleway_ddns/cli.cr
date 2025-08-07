module ScalewayDDNS
  # Handles command line interface interactions for the updater.
  class CLI
    property config : Config = Config.new
    property? run_updater : Bool = false

    def initialize : Nil
      parser = build_option_parser
      parser.parse
      run_updater? ? start_updater : show_help(parser, 1)
    end

    private def start_updater : Nil
      Process.on_terminate do |reason|
        if reason.aborted? || reason.interrupted? || reason.session_ended?
          STDOUT.puts("terminating gracefully...")
          exit(0)
        end
      end
      ScalewayDDNS::Updater.new(config).run
    end

    private def show_version : Nil
      STDOUT.puts "version #{ScalewayDDNS::VERSION}"
      exit
    end

    private def show_help(parser : OptionParser, exit_code : Int32 = 0) : Nil
      STDOUT.puts(parser)
      exit(exit_code)
    end

    private def handle_missing_option(parser : OptionParser, flag : String) : Nil
      STDERR.puts("ERROR: #{flag} is missing something.")
      STDERR.puts(parser)
      exit(1)
    end

    private def handle_invalid_option(parser : OptionParser, flag : String) : Nil
      STDERR.puts("ERROR: #{flag} is not a valid option.")
      STDERR.puts(parser)
      exit(1)
    end

    private def build_option_parser : OptionParser
      OptionParser.new do |parser|
        parser.banner = "Simple Scaleway dynamic DNS service by API\nUsage: scaleway-ddns [subcommand]"
        parser.on("run", "Run DNS update") { self.run_updater = true }
        parser.on("-v", "--version", "Show version") { show_version }
        parser.on("-h", "--help", "Show help") { show_help(parser) }
        parser.missing_option { |flag| handle_missing_option(parser, flag) }
        parser.invalid_option { |flag| handle_invalid_option(parser, flag) }
      end
    end
  end
end
