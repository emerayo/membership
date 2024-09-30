# frozen_string_literal: true

require 'rails_helper'

describe Role, type: :model do
  subject { build(:role) }

  let(:cache_key) { 'roles/all' }

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

  describe '#cached_relation' do
    subject { described_class.cached_relation }

    before do
      # Need to clear the cached properties
      Rails.cache.delete(cache_key)
    end

    context 'when cache is already set' do
      it 'returns the value' do
        expect(Rails.cache.fetch(cache_key)).to eq nil

        Rails.cache.write(cache_key, 123)

        expect(subject).to eq 123
      end
    end

    context 'when cache is not set and there is no record on the database' do
      it 'returns a blank array' do
        expect(Rails.cache.fetch(cache_key)).to eq nil

        subject

        expect(Rails.cache.fetch(cache_key)).to eq []
      end
    end

    context 'when cache is not set and there is a record on the database' do
      let!(:role) { create(:role) }

      it 'returns an array with all the Roles' do
        expect(Rails.cache.fetch(cache_key)).to eq nil

        expect(subject).to eq [role]
      end
    end
  end

  describe '#clear_cache' do
    subject { described_class.clear_cache }

    before do
      # Need to clear the cached properties
      Rails.cache.delete(cache_key)
    end

    context 'when cache is already set' do
      it 'clears the value' do
        Rails.cache.write(cache_key, 123)

        expect(Rails.cache.fetch(cache_key)).to eq 123

        subject

        expect(Rails.cache.fetch(cache_key)).to eq nil
      end
    end
  end
end
