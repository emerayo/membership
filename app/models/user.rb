# frozen_string_literal: true

class User < ApplicationRecord
  validates :avatar_url, :display_name, :first_name, :last_name, :location, presence: true
end
