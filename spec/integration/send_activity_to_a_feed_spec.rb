require 'rails_helper'

describe "send activity to a feed" do
  let(:eric) { User.create(name: "eric", email: "eric@eric.com", password: "password", password_confirmation: "password") }
  let(:jessica) { User.create(name: "jessica", email: "jessica@eric.com", password: "password", password_confirmation: "password") }
  let(:jule) { User.create(name: "jule", email: "jule@eric.com", password: "password", password_confirmation: "password") }
  let(:client) { Client.new(ENV["api_key"], ENV["api_secret"]) }

  it "returns all needed data in client" do

     expect(client.class).to eq(Client)
     expect(client.api_key).to eq("um6x4kwq6ewp")
     expect(client.api_secret).to eq("za3pya3av66z2922fxmcwexyv6zj6vthq29fey5tfnpxqey5pjdwy7379gj7dezw")
     expect(client.api_version).to eq("v1.0")
  end

  it "returns all needed data in feed" do
    ericFeed = client.feed('user', 'eric')

      expect(ericFeed.class).to eq(Feed)
      expect(ericFeed.id).to eq("user:eric")
      expect(ericFeed.slug).to eq("user")
      expect(ericFeed.user_id).to eq("eric")
      expect(ericFeed.token).to eq("xA6aMa30iM7YwREpuaxN_6W5YH4")
    end

  it "adds activity data" do
    ericFeed = client.feed('user', 'eric')
    activity_data = {:actor => 'eric', :verb => 'tweet', :object => 1, :tweet => 'Hello world'}
    activity_response = ericFeed.add_activity(activity_data)

    response_hash = {"actor"=>"eric", "duration"=>"32ms", "foreign_id"=>nil,
                     "id"=>"4b932bc8-bb7f-11e6-8080-8001506c96c7", "object"=>"1",
                     "origin"=>nil, "target"=>nil, "time"=>"2016-12-06T06:43:28.455572",
                     "to"=>[], "tweet"=>"Hello world", "verb"=>"tweet"}

    expect(activity_data[:actor]).to eq(activity_response["actor"])
    expect(activity_data[:verb]).to eq(activity_response["verb"])
    expect(activity_data[:tweet]).to eq(activity_response["tweet"])
  end
end
