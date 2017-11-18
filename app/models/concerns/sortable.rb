require 'active_support/concern'

module Sortable
  extend ActiveSupport::Concern

  included do
    scope :sorted, -> { order("regexp_replace(LOWER(name), E'#{non_sort_strings_regex}', '')") }

    # Matches on initial characters which are irrelevant for sorting
    def self.non_sort_strings_regex
      initial_chars = %W[
        \\\"
        \\\'
        \\\(
      ].join

      "^the |[#{initial_chars}]"
    end
  end
end
