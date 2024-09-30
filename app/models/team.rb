# frozen_string_literal: true

class Team < ApplicationRecord
  include Cacheable

  belongs_to :team_lead, class_name: 'User'
  has_many :memberships, dependent: :delete_all
  has_many :users, through: 'memberships'

  validates :name, presence: true
end
