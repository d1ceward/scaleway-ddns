module ScalewayDDNS
  # Configuration for the Scaleway DDNS program.
  #
  # Can be loaded from environment variables and adjusted at runtime.
  class Config
    # Secret key from Scaleway required for IP update.
    property scw_secret_key : String

    # Number of minutes of inactivity between IP checks.
    property idle_minutes : Int32

    # List of domains whose address record needs to be updated.
    property domain_list : Array(String)

    # Enables IPv4 address updates.
    property? enable_ipv4 : Bool

    # Enables IPv6 address updates.
    property? enable_ipv6 : Bool

    # Falsy values for boolean environment parsing.
    FALSY_VALUES = [
      "false", "n", "no", "0", "off", "disabled", "none", "null", "nil", "", false, 0
    ] of String | Bool | Int32

    # Creates a new instance of `ScalewayDDNS::Config` based on environment variables.
    def initialize
      @scw_secret_key = ENV["SCW_SECRET_KEY"]?.to_s
      @idle_minutes = parse_idle_minutes_from_env
      @domain_list = parse_domain_list_from_env
      @enable_ipv4 = parse_bool_env("ENABLE_IPV4")
      @enable_ipv6 = parse_bool_env("ENABLE_IPV6")
    end

    private def parse_idle_minutes_from_env : Int32
      idle = ENV["IDLE_MINUTES"]?.to_s.to_i
      (1..1440).includes?(idle) ? idle : 60
    rescue ArgumentError
      60
    end

    private def parse_domain_list_from_env : Array(String)
      ENV["DOMAIN_LIST"]?.to_s.gsub(/[[:space:]]+/, nil).split(',').reject(&.blank?)
    end

    # Parses a boolean environment variable, defaulting to true if unset.
    private def parse_bool_env(var : String) : Bool
      value = ENV[var]?
      return true unless value

      !FALSY_VALUES.includes?(value.to_s.strip.downcase)
    end
  end
end
