module ScalewayDdns
  class Config
    property scw_secret_key : String?
    property domain_list : Array(String)

    def initialize
      config = YAML.parse(File.read("config.yml"))

      @scw_secret_key = config.dig?("scaleway", "secret_key").to_s
      @domain_list = config["domains"]?.try(&.as_a?).try(&.map(&.to_s)) || [] of String
    end
  end
end
