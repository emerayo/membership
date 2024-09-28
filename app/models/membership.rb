# frozen_string_literal: true

class Membership < ApplicationRecord
  self.primary_key = %i[team_id user_id]

  belongs_to :role
  belongs_to :team
  belongs_to :user

  validates :team_id, uniqueness: { scope: :user_id, case_sensitive: false }

  before_validation :assign_default_role, unless: :role_id?

  def assign_default_role
    self.role_id = Role.default_role_id
  end
end
