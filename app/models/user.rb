class User < ApplicationRecord
  before_save { self.email = email.downcase }

  validates :name, presence: true, length: { maximum: 20 }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 50 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

  has_secure_password
  validates :password, presence: true, length: { minimum: 8 }
  has_many :tweets, dependent: :destroy

  # def initialize(api_version = "v1.0", location = nil, default_timeout = 3)
  #   location_name = "api"
  #   unless location.nil?
  #     location_name = "#{location}-api"
  #   end
  #   @base_path = "/api/#{api_version}"
  #
  #   protocol = "https"
  #   if location == "qa"
  #     protocol = "http"
  #   end
  #
  #   self.class.base_uri "#{protocol}://#{location_name}.getstream.io#{@base_path}"
  #   self.class.default_timeout default_timeout
  # end
  #
  # #
  # # Creates a feed instance
  # #
  # # @param [string] feed_slug the feed slug (eg. flat, aggregated...)
  # # @param [user_id] user_id the user_id of this feed (eg. User42)
  # #
  # # @return [Stream::Feed]
  # #
  # def feed(feed_slug, user_id)
  #   token = @signer.sign(feed_slug, user_id)
  #   Stream::Feed.new(self, feed_slug, user_id, token)
  # end
  #
  # def make_http_request(method, relative_url, params = nil, data = nil, headers = nil)
  #     headers["Content-Type"] = "application/json"
  #     headers["X-Stream-Client"] = "stream-ruby-client-#{Stream::VERSION}"
  #     body = data.to_json if ["post", "put"].include? method.to_s
  #     response = self.class.send(method, relative_url, :headers => headers, :query => params, :body => body)
  #     case response.code
  #     when 200..203
  #       return response
  #     when 204...600
  #       raise StreamApiResponseException, _build_error_message(response)
  #     end
  # end
end
