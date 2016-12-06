require "httparty"
require_relative "signer"
require "persistent_httparty"

# module Stream
  class Client
    attr_reader :api_key
    attr_reader :api_secret
    attr_reader :app_id
    attr_reader :api_version
    attr_reader :location
    attr_reader :default_timeout

    STREAM_URL_RE = %r{https\:\/\/(?<key>\w+)\:(?<secret>\w+)@((api\.)|((?<location>[-\w]+)\.))?getstream\.io\/[\w=-\?%&]+app_id=(?<app_id>\d+)}i
    VERSION = "2.4.4".freeze

    def initialize(api_key = "", api_secret = "", app_id = nil, opts = {})
      if ENV["STREAM_URL"] =~ STREAM_URL_RE && (api_key.nil? || api_key.empty?)
        matches = STREAM_URL_RE.match(ENV["STREAM_URL"])
        api_key = matches["key"]
        api_secret = matches["secret"]
        app_id = matches["app_id"]
        opts[:location] = matches["location"]
      end

      if api_key.nil? || api_key.empty?
        raise ArgumentError, "empty api_key parameter and missing or invalid STREAM_URL env variable"
      end

      @api_key = api_key
      @api_secret = api_secret
      @app_id = app_id
      @location = opts[:location]
      @api_version = opts.fetch(:api_version, "v1.0")
      @default_timeout = opts.fetch(:default_timeout, 3)
      @signer = Signer.new(api_secret)
    end

    def feed(feed_slug, user_id)
      token = @signer.sign(feed_slug, user_id)
      Feed.new(self, feed_slug, user_id, token)
    end

    def make_request(method, relative_url, signature, params = {}, data = {}, headers = {})
      headers["Authorization"] = signature
      headers["stream-auth-type"] = "jwt"

      get_http_client.make_http_request(method, relative_url, make_query_params(params), data, headers)
    end

    def get_http_client
      @http_client ||= StreamHTTPClient.new(@api_version, @location, @default_timeout)
    end

    def make_query_params(params)
      get_default_params.merge(params)
    end

    def get_default_params
      { :api_key => @api_key }
    end
  end

  class StreamHTTPClient
    include HTTParty
    persistent_connection_adapter

    attr_reader :base_path

    def initialize(api_version = "v1.0", location = nil, default_timeout = 3)
      location_name = "api"
      unless location.nil?
        location_name = "#{location}-api"
      end
      @base_path = "/api/#{api_version}"

      protocol = "https"
      if location == "qa"
        protocol = "http"
      end

      self.class.base_uri "#{protocol}://#{location_name}.getstream.io#{@base_path}"
      self.class.default_timeout default_timeout
    end

    def _build_error_message(response)
      msg = "#{response['exception']} details: #{response['detail']}"

      response["exception_fields"].map do |field, messages|
        msg << "\n#{field}: #{messages}"
      end if response.key?("exception_fields")

      msg
    end

    def make_http_request(method, relative_url, params = nil, data = nil, headers = nil)
      headers["Content-Type"] = "application/json"
      headers["X-Stream-Client"] = "stream-ruby-client-#{VERSION}"
      body = data.to_json if ["post", "put"].include? method.to_s
      response = self.class.send(method, relative_url, :headers => headers, :query => params, :body => body)
      case response.code
      when 200..203
        return response
      when 204...600
        raise StreamApiResponseException, _build_error_message(response)
      end
    end
  end
# end
