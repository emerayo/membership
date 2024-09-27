# frozen_string_literal: true

class User < ApplicationRecord
  has_many :teams, dependent: :nullify, foreign_key: :team_lead_id, inverse_of: :team_lead

  validates :avatar_url, :display_name, :first_name, :last_name, :location, presence: true
end
