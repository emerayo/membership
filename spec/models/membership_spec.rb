# frozen_string_literal: true

require 'rails_helper'

describe Membership, type: :model do
  subject { build(:membership) }

  describe 'associations' do
    it { should belong_to(:role) }
    it { should belong_to(:team) }
    it { should belong_to(:user) }
  end

  describe 'validations' do
    it { is_expected.to validate_uniqueness_of(:team_id).scoped_to(:user_id).case_insensitive }
  end
end
