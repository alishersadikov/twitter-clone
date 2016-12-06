require "httparty"
require_relative "signer"
require "persistent_httparty"

module Stream
  class Client
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
  end
end
