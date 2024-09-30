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

    describe 'prevent membership of team lead' do
      let(:team_lead) { create(:user) }
      let(:team) { create(:team, team_lead: team_lead) }
      let(:role) { create(:role, name: 'Product Owner') }
      let(:new_membership) { build(:membership, team: team, user: user, role: role) }

      context 'when user is the team lead' do
        let(:user) { team_lead }
        let(:error_msg) { 'User already assigned as Team Lead of this Team' }

        it 'returns an error' do
          expect(new_membership.valid?).to be_falsey
          expect(new_membership.errors[:user_id]).to eq [error_msg]
        end
      end

      context 'when User is not the Team Lead nor on the Team' do
        let(:user) { create(:user) }
        let!(:membership) { create(:membership, team: team) }

        it 'returns valid' do
          expect(new_membership.valid?).to be_truthy
        end
      end

      context 'when User is already a member of the Team' do
        let(:user) { create(:user) }
        let!(:membership) { create(:membership, team: team, user: user) }
        let(:new_membership) { build(:membership, team: team, user: user, role: role) }

        it 'returns an error' do
          expect(new_membership.valid?).to be_falsey
          expect(new_membership.errors[:team_id]).to eq ['has already been taken']
        end
      end
    end
  end

  describe 'delegations' do
    it { should delegate_method(:name).to(:role).with_prefix(true) }
  end

  describe 'callbacks' do
    describe 'after_initialize' do
      let!(:default_role) { create(:role) }

      before do
        # Need to clear the cached properties
        Rails.cache.delete('cached_default_role_id')
      end

      context 'when the Membership is initialized without a Role' do
        let(:membership) { Membership.new(role: nil) }

        it 'should associate the default Role to the record' do
          expect(membership.role_id).to eq default_role.id
        end
      end

      context 'when the Membership has a Role associated' do
        let!(:role) { create(:role, name: 'Product Owner') }
        let(:membership) { build(:membership, role: role) }

        it 'should not change the role_id' do
          expect(membership.role_id).to eq role.id
        end
      end
    end
  end
end
