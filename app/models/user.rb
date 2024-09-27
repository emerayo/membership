# frozen_string_literal: true

class User < ApplicationRecord
  validates :email, :name, presence: true
end
