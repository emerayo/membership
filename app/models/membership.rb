# frozen_string_literal: true

class Membership < ApplicationRecord
  self.primary_key = %i[team_id user_id]

  belongs_to :role
  belongs_to :team
  belongs_to :user

  validates :team_id, uniqueness: { scope: :user_id, case_sensitive: false }
  validate :membership_different_team_lead, if: :team_id?

  after_initialize :assign_default_role, unless: :role_id?

  delegate :name, to: :role, prefix: true

  private

  def membership_different_team_lead
    return unless team.team_lead_id == user_id

    errors.add(:user_id, :user_is_team_lead)
  end

  def assign_default_role
    self.role_id = Role.default_role_id
  end
end
