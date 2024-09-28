# frozen_string_literal: true

FactoryBot.define do
  factory :membership do
    role
    team
    user
  end
end
