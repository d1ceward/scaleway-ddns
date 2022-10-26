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
        Log.info { "Starting DNS update..." }

        begin
          current_ip = IP.current_ip
          @config.domain_list.each do |domain|
            update_single_domain(domain, current_ip)
          end
        rescue exception : IPError
          Log.error { exception.message }
        end

        Log.info { "DNS update finished, sleeping..." }
        sleep(@config.idle_minutes * 60)
      end
    rescue exception : GlobalError
      Log.error { exception.message }
      Log.info { "Exiting..." }
      exit(1)
    end

    private def update_single_domain(domain : String, ip : String)
      root_domain = domain.split('.')[-2..].join(".")
      sub_domain = domain.split('.')[..-3].join(".")
      address_record = @request.address_record_list(root_domain)
                               .find { |record| record[:name] == sub_domain }

      return Log.warn { "No matching subdomain name: #{sub_domain}" } unless address_record

      if address_record[:data] == ip
        Log.info { "Identical IP address for #{domain}, no update required "}
        return
      end

      @request.update_address_record(root_domain, ip , address_record)
    rescue exception : RequestError
      Log.error { exception.message }
    end
  end
end
