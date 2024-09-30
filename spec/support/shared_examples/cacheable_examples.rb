# frozen_string_literal: true

RSpec.shared_examples 'Cacheable' do |cache_key, klass_name, trait = nil, update_field = :name|
  subject { described_class.create }

  describe 'callbacks' do
    before do
      # Need to clear the cached properties
      Rails.cache.delete(cache_key)
    end

    describe 'after_commit' do
      let!(:record1) { create(klass_name, trait) }

      describe 'when creating a new record' do
        let!(:record2) { build(klass_name) }

        it 'clears the cache' do
          described_class.cached_relation

          expect(Rails.cache.fetch(cache_key)).to eq [record1]

          record2.save

          expect(Rails.cache.fetch(cache_key)).to eq nil
        end
      end

      describe 'when updating a record' do
        it 'clears the cache' do
          described_class.cached_relation

          expect(Rails.cache.fetch(cache_key)).to eq [record1]

          record1.update(update_field => 'new name')

          expect(Rails.cache.fetch(cache_key)).to eq nil
        end
      end

      describe 'when destroying a record' do
        it 'clears the cache' do
          described_class.cached_relation

          expect(Rails.cache.fetch(cache_key)).to eq [record1]

          record1.destroy

          expect(Rails.cache.fetch(cache_key)).to eq nil
        end
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
      let!(:record) { create(klass_name) }

      it 'returns an array with all the records' do
        expect(Rails.cache.fetch(cache_key)).to eq nil

        expect(subject).to eq [record]
      end
    end
  end

  describe '#clear_cache' do
    let!(:record) { create(klass_name) }

    subject { described_class.clear_cache }

    before do
      # Need to clear the cached properties
      Rails.cache.delete(cache_key)
    end

    context 'when cache is already set' do
      it 'clears the value' do
        described_class.cached_relation

        expect(Rails.cache.fetch(cache_key)).to eq [record]

        subject

        expect(Rails.cache.fetch(cache_key)).to eq nil
      end
    end
  end

  describe '#relation_cache_key' do
    subject { described_class.relation_cache_key }

    before do
      # Need to clear the cached properties
      Rails.cache.delete(cache_key)
    end

    it 'returns the value for the relation_cache_key' do
      expect(subject).to eq "#{klass_name}s/all"
    end
  end
end
