module ScalewayDDNS
  class Config
    property scw_secret_key : String
    property idle_minutes : Int32
    property domain_list : Array(String)

    def initialize
      @scw_secret_key = ENV["SCW_SECRET_KEY"]?.to_s
      @idle_minutes = parse_idle_minutes_from_env
      @domain_list = parse_domain_list_from_env
    end

    private def parse_idle_minutes_from_env : Int32
      idle_minutes = ENV["IDLE_MINUTES"]?.to_s.to_i

      (1..1440).includes?(idle_minutes) ? idle_minutes : 60
    rescue ArgumentError
      60
    end

    private def parse_domain_list_from_env : Array(String)
      ENV["DOMAIN_LIST"]?.to_s.gsub(/[[:space:]]+/, nil).split(',').reject(&.blank?)
    end
  end
end
