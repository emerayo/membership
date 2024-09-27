# frozen_string_literal: true

require 'rails_helper'

describe Membership, type: :model do
  subject { build(:membership) }

  describe 'associations' do
    it { should belong_to(:team) }
    it { should belong_to(:user) }
  end
end
