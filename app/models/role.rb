# frozen_string_literal: true

class Role < ApplicationRecord
  include Cacheable

  DEFAULT_ROLE = 'Developer'

  has_many :memberships, dependent: :nullify

  validates :name, presence: true, uniqueness: true

  before_destroy :prevent_default_role_destroy

  scope :by_name, ->(string) { where('name ILIKE ?', "%#{string}%") }

  def self.default_role_id
    Rails.cache.fetch('cached_default_role_id', expires_in: 1.hour) do
      Role.find_by(name: DEFAULT_ROLE)&.id
    end
  end

  private

  def prevent_default_role_destroy
    return unless name == DEFAULT_ROLE

    errors.add(:base, :cannot_destroy_default_role)
    throw :abort
  end
end
