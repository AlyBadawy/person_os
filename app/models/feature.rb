class Feature < ApplicationRecord
  has_many :features_users, dependent: :destroy
  has_many :users, through: :features_users

  validates :name, presence: true, uniqueness: true
end
