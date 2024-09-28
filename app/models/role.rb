# frozen_string_literal: true

class Role < ApplicationRecord
  has_many :memberships, dependent: :nullify

  validates :name, presence: true, uniqueness: true
end
