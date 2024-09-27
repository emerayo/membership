# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  subject { build(:user) }

  describe 'associations' do
    it do
      should have_many(:teams).dependent(:nullify)
                              .with_foreign_key('team_lead_id')
                              .inverse_of(:team_lead)
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_presence_of(:last_name) }
    it { is_expected.to validate_presence_of(:display_name) }
    it { is_expected.to validate_presence_of(:avatar_url) }
    it { is_expected.to validate_presence_of(:location) }
  end
end
