module ScalewayDDNS
  class Config
    property scw_secret_key : String
    property domain_list : Array(String)

    def initialize
      @scw_secret_key = ENV["SCW_SECRET_KEY"]?.to_s
      @domain_list = parse_domain_list_from_env
    end

    private def parse_domain_list_from_env
      ENV["DOMAIN_LIST"]?.to_s.gsub(/[[:space:]]+/, nil).split(',').reject(&.blank?)
    end
  end
end
