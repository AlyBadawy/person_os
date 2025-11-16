class EventEntry < ApplicationRecord
  belongs_to :eventable
  belongs_to :user

  before_create :set_defaults

  validate :user_is_same_as_eventable_user

  private

  def set_defaults
    self.metadata ||= {}
    self.occurred_at ||= Time.current
    self.user ||= eventable.user
  end

  def user_is_same_as_eventable_user
    return if eventable.nil? || user.nil?
    if eventable.user_id != user_id
      errors.add(:user, "must be the same as the eventable's user")
    end
  end
end
