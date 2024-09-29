# frozen_string_literal: true

require 'rails_helper'

describe Role, type: :model do
  subject { build(:role) }

  describe 'associations' do
    it { should have_many(:memberships) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name) }
  end

  describe 'callbacks' do
    describe 'before_destroy' do
      context 'when destroying the default Role' do
        let!(:role) { create(:role) }

        it 'should prevent the destroy and return an error' do
          expect { role.destroy }.not_to(change { Role.count })

          expect(role.errors[:base]).to eq ['Can not destroy default role (Developer)']
        end
      end

      context 'when destroying a role different than the default Role' do
        let!(:role) { create(:role, name: 'Product Owner') }

        it 'should destroy the Role' do
          expect { role.destroy }.to change { Role.count }.by(-1)
        end
      end
    end
  end

  describe '#default_role_id' do
    subject { described_class.default_role_id }

    before do
      # Need to clear the cached properties
      Rails.cache.delete('cached_default_role_id')
    end

    context 'when there is a Developer Role' do
      let!(:role) { create(:role) }

      it 'returns the developer Role id' do
        expect(subject).to eq role.id
      end
    end

    context 'when there is not a Developer Role' do
      it 'returns the developer Role id' do
        expect(subject).to be_nil
      end
    end
  end
end
