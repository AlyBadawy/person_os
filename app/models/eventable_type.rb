class EventableType < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  has_many :eventables, dependent: :restrict_with_error
end
