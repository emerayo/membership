# frozen_string_literal: true

module Cacheable
  extend ActiveSupport::Concern

  included do
    after_commit :clear_cache

    delegate :clear_cache, to: :class
  end

  class_methods do
    def cached_relation
      Rails.cache.fetch(relation_cache_key, expires_in: 1.hour) do
        all.to_a
      end
    end

    def clear_cache
      Rails.cache.delete(relation_cache_key)
    end

    def relation_cache_key
      "#{table_name}/all"
    end
  end
end
