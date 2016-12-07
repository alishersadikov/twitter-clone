require 'rails_helper'
# require 'stream'

describe "following a user" do
  let(:eric) { User.create(name: "eric", email: "eric@eric.com", password: "password", password_confirmation: "password") }
  let(:jessica) { User.create(name: "jessica", email: "jessica@eric.com", password: "password", password_confirmation: "password") }
  let(:jule) { User.create(name: "jule", email: "jule@eric.com", password: "password", password_confirmation: "password") }
  let(:client) { Client.new(ENV["api_key"], ENV["api_secret"]) }
  let(:ericFeed) { client.feed('user', 'eric') }
  let(:activity_data) { {:actor => 'eric', :verb => 'tweet', :object => 1, :tweet => 'Hello world'} }
  let(:activity_response) { ericFeed.add_activity(activity_data) }

  xit "returns all activities in the following user's feed" do
    jessicaFlatFeed = client.feed('timeline', 'jessica')
    jessicaFlatFeed.follow('user', 'eric')
    new_activity_data = {:actor => 1, :verb => 'tweet', :object => 1, :tweet => 'Hello Stream'}
    new_activity_response = ericFeed.add_activity(new_activity_data)
    response = jessicaFlatFeed.get(:limit=>3)

    response_hash = {
        "duration": "16ms",
        "next": "/api/v1.0/feed/timeline/jessica/?id_lt=81f19206-bbeb-11e6-8080-80017456cd64&api_key=um6x4kwq6ewp&limit=3&location=unspecified&offset=0",
        "results": [
            {
                "actor": "eric",
                "foreign_id": null,
                "id": "7876eaa4-bbec-11e6-8080-80017456cd64",
                "object": "1",
                "origin": "user:eric",
                "target": null,
                "time": "2016-12-06T19:44:58.911402",
                "to": [],
                "verb": "watch",
                "video_name": "Happy Cat",
                "youtube_id": "z_AbfPXTKms"
            },
            {
                "actor": "eric",
                "foreign_id": null,
                "id": "095f9e2c-bbec-11e6-8080-8001506c96c7",
                "object": "1",
                "origin": "user:eric",
                "target": null,
                "time": "2016-12-06T19:41:52.531614",
                "to": [],
                "tweet": "Hello world",
                "verb": "tweet",
                "video_name": null,
                "youtube_id": null
            },
            {
                "actor": "eric",
                "foreign_id": null,
                "id": "81f19206-bbeb-11e6-8080-80017456cd64",
                "object": "1",
                "origin": "user:eric",
                "target": null,
                "time": "2016-12-06T19:38:05.317991",
                "to": [],
                "tweet": null,
                "verb": "watch",
                "video_name": "Post-Rock Song",
                "youtube_id": "0m_lU2RA9Ak"
            }
        ]
    }
  end
end
