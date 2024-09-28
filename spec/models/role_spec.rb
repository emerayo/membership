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

  describe '#default_role_id' do
    subject { described_class.default_role_id }

    before do
      # Need to clear the cached properties
      Rails.cache.delete('cached_default_role_id')
    end

    context 'when there is a Developer role' do
      let!(:role) { create(:role) }

      it 'returns the developer role id' do
        expect(subject).to eq role.id
      end
    end

    context 'when there is not a Developer role' do
      it 'returns the developer role id' do
        expect(subject).to be_nil
      end
    end
  end
end
