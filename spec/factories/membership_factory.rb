# frozen_string_literal: true

FactoryBot.define do
  factory :membership do
    team
    user
  end
end
