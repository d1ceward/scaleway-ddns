module ScalewayDDNS
  class Updater
    RECORD_TYPES = {"ipv4" => "A", "ipv6" => "AAAA"}

    def initialize(@config : Config)
      @request = Request.new(@config.scw_secret_key.to_s)
    end

    def run
      raise_if_domain_list_empty

      loop do
        Log.info { "Starting DNS update..." }
        update_all_domains
        Log.info { "DNS update finished, sleeping..." }
        sleep(@config.idle_minutes.minutes)
      end
    rescue exception : GlobalError
      Log.error { exception.message }
      Log.info { "Exiting..." }
      exit(1)
    end

    private def raise_if_domain_list_empty
      if @config.domain_list.none?
        raise GlobalError.new("Empty domain list, please check configuration variables.")
      end
    end

    private def update_all_domains
      ips = IP.current_ips(@config.enable_ipv4?, @config.enable_ipv6?)
      @config.domain_list.each { |domain| update_domain(domain, ips) }
    rescue exception : IPError
      Log.error { exception.message }
    end

    private def update_domain(domain : String, ips : Hash(String, String))
      root_domain, sub_domain = extract_domains(domain)
      address_records = @request.address_record_list(root_domain)

      RECORD_TYPES.each do |version, record_type|
        update_record_if_needed(domain, sub_domain, root_domain, address_records, ips, version, record_type)
      end
    rescue exception : RequestError
      Log.error { exception.message }
    end

    private def extract_domains(domain : String) : Tuple(String, String)
      parts = domain.split('.')
      root_domain = parts[-2..].join(".")
      sub_domain = parts[..-3].join(".")
      {root_domain, sub_domain}
    end

    private def update_record_if_needed(
      domain : String,
      sub_domain : String,
      root_domain : String,
      address_records : Array(Hash(Symbol, Int32 | String)),
      ips : Hash(String, String),
      version : String,
      record_type : String
    )
      ip = ips[version]?
      return if ip.nil? || ip.empty?

      address_record = address_records.find do |record|
        record[:name] == sub_domain && record[:type] == record_type
      end

      unless address_record
        Log.warn { "No matching #{record_type} record for subdomain name: #{sub_domain}" }
        return
      end

      if address_record[:data] == ip
        Log.info { "Identical #{record_type} address for #{domain}, no update required" }
        return
      end

      @request.update_address_record(root_domain, ip, address_record, record_type)
    end
  end
end
