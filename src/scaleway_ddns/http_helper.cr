module ScalewayDDNS
  # Shared HTTP plumbing for the external APIs used by the updater.
  module HTTPHelper
    # Maximum time allowed to establish a connection.
    CONNECT_TIMEOUT = 10.seconds

    # Maximum time allowed to receive a response once connected.
    READ_TIMEOUT = 30.seconds

    # Number of times a request is attempted before giving up.
    MAX_ATTEMPTS = 3

    # Base delay between two attempts, multiplied by the attempt number.
    RETRY_DELAY = 1.second

    # Executes a request against *host*, retrying transient connection failures.
    #
    # Returns a synthetic 408 response when every attempt fails, so that callers only have to deal with a
    # status code.
    def self.execute(
      host : String,
      method : String,
      path : String,
      headers : HTTP::Headers? = nil,
      body : String? = nil,
    ) : HTTP::Client::Response
      attempt = 0

      loop do
        attempt += 1

        begin
          return HTTP::Client.new(URI.new("https", host)) do |client|
            client.connect_timeout = CONNECT_TIMEOUT
            client.read_timeout = READ_TIMEOUT
            client.exec(method, path, headers, body)
          end
        rescue exception : IO::Error | OpenSSL::Error
          return HTTP::Client::Response.new(408) if attempt >= MAX_ATTEMPTS

          Log.warn { "#{host}: #{exception.message}, retrying (#{attempt}/#{MAX_ATTEMPTS})" }
          sleep(RETRY_DELAY * attempt)
        end
      end
    end
  end
end
