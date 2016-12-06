require 'rails_helper'
require 'stream'

describe "request" do
  it "flat feed" do
    eric = User.create(name: "eric", email: "eric@eric.com", password: "password", password_confirmation: "password")
    jessica = User.create(name: "jessica", email: "jessica@eric.com", password: "password", password_confirmation: "password")
    jule = User.create(name: "jule", email: "jule@eric.com", password: "password", password_confirmation: "password")

    client = Stream::Client.new('um6x4kwq6ewp', 'za3pya3av66z2922fxmcwexyv6zj6vthq29fey5tfnpxqey5pjdwy7379gj7dezw')

    ericFeed = client.feed('user', 'eric')
    activity_data = {:actor => 'eric', :verb => 'tweet', :object => 1, :tweet => 'Hello world'}

    activity_response = ericFeed.add_activity(activity_data)

    jessicaFlatFeed = client.feed('timeline', 'jessica')
    jessicaFlatFeed.follow('user', 'eric')
    response = jessicaFlatFeed.get(:limit=>3)

    juleAggregatedFeed = client.feed('timeline_aggregated', 'jule')
    juleAggregatedFeed.follow('user', 'eric')

    response = juleAggregatedFeed.get(:limit=>3)

  end
end
