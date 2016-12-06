require "signer"

# module Stream
  class Feed
    attr_reader :id
    attr_reader :slug
    attr_reader :user_id
    attr_reader :token

    def initialize(client, feed_slug, user_id, token)
      unless valid_feed_slug feed_slug
        raise StreamInputData, "feed_slug can only contain alphanumeric characters plus underscores"
      end

      unless valid_user_id user_id
        raise StreamInputData, "user_id can only contain alphanumeric characters plus underscores and dashes"
      end

      @id = "#{feed_slug}:#{user_id}"
      @client = client
      @user_id = user_id
      @slug = feed_slug
      @feed_name = "#{feed_slug}#{user_id}"
      @feed_url = "#{feed_slug}/#{user_id}"
      @token = token
    end

    def add_activity(activity_data)
      uri = "/feed/#{@feed_url}/"
      activity_data[:to] &&= sign_to_field(activity_data[:to])
      auth_token = create_jwt_token("feed", "write")

      @client.make_request(:post, uri, auth_token, {}, activity_data)
    end

    def valid_feed_slug(feed_slug)
      !feed_slug[/^[a-zA-Z0-9_]+$/].nil?
    end

    def valid_user_id(user_id)
     !user_id.to_s[/^[\w-]+$/].nil?
    end

    def create_jwt_token(resource, action, feed_id = nil, user_id = nil)
      feed_id = @feed_name if feed_id.nil?
      Signer.create_jwt_token(resource, action, @client.api_secret, feed_id, user_id)
    end
  end
# end
