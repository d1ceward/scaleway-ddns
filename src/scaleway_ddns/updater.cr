module ScalewayDdns
  class Updater
    def initialize(@config : Config)
      @request = ScalewayDdns::Request.new(config)
    end

    def perform
      @config.domain_list.each do |domain|
        p @request.address_record_list(domain)
      end
    end
  end
end
