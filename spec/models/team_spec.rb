# frozen_string_literal: true

require 'rails_helper'

describe Team, type: :model do
  subject { build(:team) }

  describe 'associations' do
    it { should belong_to(:team_lead).class_name('User') }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
  end
end
