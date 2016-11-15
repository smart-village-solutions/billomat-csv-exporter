require "addressable/uri"

# Base class for POST and GET requests
#
# @author Marco Metz, Holger Frohloff
# @uri      [String] The Uri that is targeted with the request
# @login    [String] default=nil, A login for HTTP Basic Auth
# @password [String] default=nil, A password for HTTP Basic Auth
# @params   [Hash]   An optional hash of parameters for the request
#
module BillomatCsvExporter
  class ApiRequestService
    def initialize(uri, port, params = {}, headers = {})
      @uri = uri
      @port = port
      @params = params
      @headers = headers
    end

    def get_request
      uri = Addressable::URI.parse(@uri.strip).normalize
      uri.query = [uri.query, URI.encode_www_form(@params)].join("&") if @params && @params.any?
      request = Net::HTTP::Get.new(uri)
      @headers.each do |key, value|
        request.add_field key, value
      end

      http = Net::HTTP.new(uri.hostname, @port)

      if @uri.include?("https://")
        http.use_ssl = true
        http.ssl_version = :SSLv23
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end

      http.request(request)

    rescue Timeout::Error
      raise ApiTimeoutError
    end

    def post_request
      uri = Addressable::URI.parse(@uri.strip).normalize

      http = Net::HTTP.new(uri.host, @port)

      if @uri.include?("https://")
        http.use_ssl = true
        http.ssl_version = :SSLv23
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end

      request = Net::HTTP::Post.new(uri.path, "Content-Type" => "application/json")
      request.body = @params.to_json

      @headers.each do |key, value|
        request.add_field key, value
      end

      http.request(request)
    end
  end

  # A custom error class.
  #
  # API requests might time out. Whenever a timeout error occurs, a custom ApiTimeoutError is raised.
  # Currently this has no specific effect.
  #
  # @author Holger Frohloff
  class ApiTimeoutError < StandardError
  end
end