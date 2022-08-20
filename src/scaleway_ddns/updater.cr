module ScalewayDDNS
  class Updater
    def initialize(@config : Config)
      @request = Request.new(config)
    end

    def perform
      return Log.error { "Empty domain list, please check configuration file." } if @config.domain_list.none?

      @config.domain_list.each do |domain|
        p @request.address_record_list(domain)
      end
    end
  end
end
