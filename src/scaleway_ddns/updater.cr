module ScalewayDDNS
  class Updater
    NO_DOMAIN_ERROR = "Empty domain list, please check configuration variables."

    def initialize(@config : Config)
      @request = Request.new(config.scw_secret_key.to_s)
    end

    def run
      Log.info { "Starting DNS update..."}
      raise GlobalError.new(NO_DOMAIN_ERROR) if @config.domain_list.none?

      current_ip = IP.current_ip
      @config.domain_list.each do |domain|
        update_single_domain(domain, current_ip)
      end

      Log.info { "DNS update finished, exiting..."}
    rescue exception : GlobalError
      Log.error { exception.message }
      Log.info { "Exiting..."}
      exit(1)
    end

    private def update_single_domain(domain : String, ip : String)
      p @request.address_record_list(domain)
    rescue exception : RequestError
      Log.error { exception.message }
    end
  end
end
