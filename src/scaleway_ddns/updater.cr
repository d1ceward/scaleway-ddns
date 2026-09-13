module ScalewayDDNS
  class Updater
    RECORD_TYPES = {"ipv4" => "A", "ipv6" => "AAAA"}

    # Separator between a record name and its explicit DNS zone in `DOMAIN_LIST`.
    ZONE_SEPARATOR = ':'

    # Reported when no secret key is configured.
    MISSING_SECRET_KEY = "Empty secret key, please check configuration variables."

    # Reported when no domain is configured.
    EMPTY_DOMAIN_LIST = "Empty domain list, please check configuration variables."

    def initialize(@config : Config) : Nil
      @request = Request.new(@config.scw_secret_key)
    end

    # Runs update cycles until the process is terminated.
    def run : NoReturn
      raise_if_misconfigured

      loop do
        Log.info { "Starting DNS update..." }
        update
        Log.info { "DNS update finished, sleeping..." }
        sleep(@config.idle_minutes.minutes)
      end
    rescue exception : GlobalError
      Log.error { exception.message }
      Log.info { "Exiting..." }
      exit(1)
    end

    # Performs a single update cycle for every configured domain.
    def update : Nil
      ips = IP.current_ips(@config.enable_ipv4?, @config.enable_ipv6?)
      if ips.empty?
        Log.warn { "No IP address available, skipping this update" }
        return
      end

      record_types = ips.keys.compact_map { |version| RECORD_TYPES[version]? }
      zone_records = {} of String => Array(AddressRecord)
      @config.domain_list.each { |entry| update_domain(entry, ips, record_types, zone_records) }
    rescue exception : IPError
      Log.error { exception.message }
    end

    private def raise_if_misconfigured
      raise GlobalError.new(MISSING_SECRET_KEY) if @config.scw_secret_key.blank?
      raise GlobalError.new(EMPTY_DOMAIN_LIST) if @config.domain_list.none?
    end

    private def update_domain(
      entry : String,
      ips : Hash(String, String),
      record_types : Array(String),
      zone_records : Hash(String, Array(AddressRecord)),
    )
      domains = extract_domains(entry)
      return if domains.nil?
      root_domain, sub_domain, domain = domains

      address_records = zone_records.fetch(root_domain) do
        zone_records[root_domain] = @request.address_record_list(root_domain, record_types)
      end

      ips.each do |version, ip|
        record_type = RECORD_TYPES[version]?
        next if record_type.nil?

        update_record_if_needed(domain, sub_domain, root_domain, address_records, ip, record_type)
      end
    rescue exception : RequestError
      Log.error { exception.message }
    end

    # Splits a `DOMAIN_LIST` entry into its DNS zone, its record name relative to that zone, and the full
    # domain name.
    #
    # The zone defaults to the last two labels of the entry, which is wrong for multi-label suffixes such as
    # `co.uk`. Such entries can carry their zone explicitly, as in `home.example.co.uk:example.co.uk`.
    #
    # Returns `nil` when the entry cannot be split, so that a single bad entry does not take the whole updater
    # down.
    private def extract_domains(entry : String) : Tuple(String, String, String)?
      domain, _, root_domain = entry.partition(ZONE_SEPARATOR)

      if root_domain.empty?
        labels = domain.split('.')
        if labels.size < 2
          Log.warn { "Skipping invalid domain '#{entry}', expected at least a zone like example.com" }
          return
        end

        root_domain = labels.last(2).join('.')
      elsif domain != root_domain && !domain.ends_with?(".#{root_domain}")
        Log.warn { "Skipping invalid domain '#{entry}', '#{domain}' is not part of zone '#{root_domain}'" }
        return
      end

      sub_domain = domain == root_domain ? "" : domain[0, domain.size - root_domain.size - 1]
      {root_domain, sub_domain, domain}
    end

    private def update_record_if_needed(
      domain : String,
      sub_domain : String,
      root_domain : String,
      address_records : Array(AddressRecord),
      ip : String,
      record_type : String,
    )
      return if ip.empty?

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
