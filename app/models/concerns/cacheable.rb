# frozen_string_literal: true

module Cacheable
  extend ActiveSupport::Concern

  included do
    after_commit :clear_cache

    delegate :clear_cache, to: :class

    class << self
      def cached_relation
        Rails.cache.fetch("#{table_name}/all", expires_in: 1.hour) do
          all.to_a
        end
      end

      def clear_cache
        Rails.cache.delete("#{table_name}/all")
      end
    end
  end
end
