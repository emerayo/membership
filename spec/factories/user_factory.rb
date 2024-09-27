# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    display_name { first_name + last_name }
    avatar_url { Faker::Internet.url }
    location { Faker::Locations::Australia.location }
  end
end
