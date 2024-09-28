# frozen_string_literal: true

require 'rails_helper'

describe Role, type: :model do
  subject { build(:role) }

  describe 'associations' do
    it { should have_many(:membership) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name) }
  end
end
