# frozen_string_literal: true

class Team < ApplicationRecord
  belongs_to :team_lead, class_name: 'User'

  validates :name, presence: true
end
