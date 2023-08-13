module ScalewayDDNS
  # The Updater class handles the actual DDNS update process.
  class Updater
    # Initializes an instance of the Updater class with a configuration object.
    def initialize(@config : Config)
      # Create a new instance of the Request class with the provided Scaleway secret key.
      @request = Request.new(config.scw_secret_key.to_s)
    end

    # Initiates the DNS update process and continuously updates the DNS records based on the configured interval.
    def run
      # Check if the domain list is empty in the configuration.
      if @config.domain_list.none?
        raise GlobalError.new("Empty domain list, please check configuration variables.")
      end

      # Start an infinite loop to keep updating DNS records.
      loop do
        Log.info { "Starting DNS update..." }

        # Attempt to fetch the current public IP address.
        begin
          current_ip = IP.current_ip

          # Iterate through the list of domains and update each domain's DNS record.
          @config.domain_list.each do |domain|
            update_single_domain(domain, current_ip)
          end
        rescue exception : IPError
          Log.error { exception.message }
        end

        Log.info { "DNS update finished, sleeping..." }
        # Sleep for the specified idle interval before the next update.
        sleep(@config.idle_minutes * 60)
      end
    rescue exception : GlobalError
      Log.error { exception.message }
      Log.info { "Exiting..." }
      exit(1)
    end

    private def update_single_domain(domain : String, ip : String)
      # Extract the root domain and subdomain from the full domain name.
      root_domain = domain.split('.')[-2..].join(".")
      sub_domain = domain.split('.')[..-3].join(".")

      # Find the address record associated with the subdomain in the DNS records.
      address_record = @request.address_record_list(root_domain)
                               .find { |record| record[:name] == sub_domain }

      # If no matching address record is found, log a warning.
      unless address_record
        Log.warn { "No matching subdomain name: #{sub_domain}" }
        return
      end

      # Check if the current IP matches the IP in the address record.
      if address_record[:data] == ip
        Log.info { "Identical IP address for #{domain}, no update required "}
        return
      end

      # Update the address record with the new IP.
      @request.update_address_record(root_domain, ip , address_record)
    rescue exception : RequestError
      Log.error { exception.message }
    end
  end
end
