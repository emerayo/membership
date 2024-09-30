# frozen_string_literal: true

RSpec.shared_examples 'Cacheable' do |cache_key, klass_name|
  subject { described_class.create }

  before do
    # Need to clear the cached properties
    Rails.cache.delete(cache_key)
  end

  describe '#cached_relation' do
    subject { described_class.cached_relation }

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
    subject { described_class.clear_cache }

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
