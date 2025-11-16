class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :features_users, dependent: :destroy
  has_many :features, through: :features_users

  has_many :eventables, dependent: :destroy
  has_many :event_entries, dependent: :destroy
end
