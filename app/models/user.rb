# frozen_string_literal: true

class User < ApplicationRecord
  include Cacheable

  has_many :leading_teams, dependent: :nullify, foreign_key: :team_lead_id, inverse_of: :team_lead,
                           class_name: 'Team'
  has_many :memberships, dependent: :delete_all
  has_many :teams, through: 'memberships'

  validates :avatar_url, :display_name, :first_name, :last_name, :location, presence: true
end
