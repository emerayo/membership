# frozen_string_literal: true

FactoryBot.define do
  factory :role do
    name { 'Developer' }
  end

  trait :tester do
    name { 'Tester' }
  end
end
