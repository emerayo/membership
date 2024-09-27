# frozen_string_literal: true

FactoryBot.define do
  factory :team do
    name { Faker::Book.title }
    association :team_lead, factory: :user
  end
end
