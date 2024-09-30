# frozen_string_literal: true

require 'rails_helper'

describe Team, type: :model do
  subject { build(:team) }

  it_behaves_like 'Cacheable', 'teams/all', :team

  describe 'associations' do
    it { should belong_to(:team_lead).class_name('User') }

    it { should have_many(:memberships).dependent(:delete_all) }
    it { should have_many(:users).through(:memberships) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
  end
end
