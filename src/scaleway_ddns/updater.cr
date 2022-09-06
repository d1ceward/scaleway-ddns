module ScalewayDDNS
  class Updater
    def initialize(@config : Config)
      @request = Request.new(config.scw_secret_key.to_s)
    end

    def run
      if @config.domain_list.none?
        raise GlobalError.new("Empty domain list, please check configuration variables.")
      end

      loop do
        Log.info { "Starting DNS update..."}

        current_ip = IP.current_ip
        @config.domain_list.each do |domain|
          update_single_domain(domain, current_ip)
        end

        Log.info { "DNS update finished, sleeping..."}
        sleep(@config.idle_minutes * 60)
      end
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
