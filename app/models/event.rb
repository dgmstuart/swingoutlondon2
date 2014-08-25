class Event < ActiveRecord::Base
  has_many :event_seeds, inverse_of: :event
  has_many :event_generators, through: :event_seeds
  has_many :event_instances, through: :event_seeds

  accepts_nested_attributes_for :event_seeds

  validates :name, presence: true
  # TODO - need to separately reject totally missing generators/seeds?

  scope :sort, -> { order("regexp_replace(LOWER(name), E'#{non_sort_strings_regex}', '')") }

  # Matches on initial characters which are irrelevant for sorting
  def self.non_sort_strings_regex
    initial_chars = %W(
      \\\"
      \\\'
      \\\(
    ).join

    "^the |[#{initial_chars}]"
  end
end
