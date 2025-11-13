class EventEntry < ApplicationRecord
  belongs_to :eventable

  delegate :user, to: :eventable
  delegate :eventable_type, to: :eventable
end
