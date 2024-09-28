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

  describe 'callbacks' do
    describe 'before_validation' do
      let!(:default_role) { create(:role) }

      before do
        # Need to clear the cached properties
        Rails.cache.delete('cached_default_role_id')
      end

      context 'when the Membership does not have a Role associated' do
        let(:membership) { build(:membership, role: nil) }

        it 'should associate the default Role to the record' do
          expect(membership.role_id).to eq nil

          membership.valid?

          expect(membership.role_id).to eq default_role.id
        end
      end

      context 'when the Membership has a Role associated' do
        let!(:role) { create(:role, name: 'Product Owner') }
        let(:membership) { build(:membership, role: role) }

        it 'should not change the role_id' do
          membership.valid?

          expect(membership.role_id).to eq role.id
        end
      end
    end
  end
end
