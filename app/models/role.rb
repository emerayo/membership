# frozen_string_literal: true

class Role < ApplicationRecord
  DEFAULT_ROLE = 'Developer'

  has_many :memberships, dependent: :nullify

  validates :name, presence: true, uniqueness: true

  def self.default_role_id
    Rails.cache.fetch('cached_default_role_id', expires_in: 1.hour) do
      Role.find_by(name: DEFAULT_ROLE)&.id
    end
  end
end
