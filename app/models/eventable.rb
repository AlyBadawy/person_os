class Eventable < ApplicationRecord
  belongs_to :user
  belongs_to :eventable_type

  has_many :event_entries, dependent: :nullify

  validates :name, presence: true, uniqueness: { scope: [:user_id, :eventable_type_id] }
  validates :starts_on, presence: true
  validate :ends_on_after_starts_on

  before_save :require_schedule_keys

  def applies_on?(date)
    return false unless active

    return false if date < starts_on ||
      (ends_on.present? && date > ends_on) ||
      schedule["freq"] == EventableFrequency.none

    return true if (
        schedule["freq"] == EventableFrequency.once && date == starts_on
      ) ||
      applies_on_daily(date) ||
      applies_on_weekly(date) ||
      applies_on_bi_weekly(date) ||
      applies_on_custom_dates(date) ||
      applies_on_monthly(date)

    false
  end

  private

  def ends_on_after_starts_on
    return if ends_on.blank? || starts_on.blank?
    errors.add(:ends_on, "must be after start") if ends_on < starts_on
  end

  def require_schedule_keys
      defaults = {
        "freq" => EventableFrequency.once,
        "days_in_week_one" => [],
        "days_in_week_two" => [],
        "days_in_month" => [],
        "custom_dates" => [],
        "multiple_per_day" => 0,
      }

      current = (self.schedule || {}).with_indifferent_access

      current["multiple_per_day"] = 0 if current.key?("multiple_per_day") &&
        current["multiple_per_day"].is_a?(Hash) &&
        current["multiple_per_day"].empty?

      final = defaults.merge(current.to_h) { |_key, default_val, current_val| current_val }
      self.schedule = final
  end

  def applies_on_daily(date)
    return false unless schedule["freq"] == EventableFrequency.daily

    true
  end

  def applies_on_weekly(date)
    return false unless schedule["freq"] == EventableFrequency.weekly

    schedule["days_in_week_one"].include?(date.cwday)
  end

  def applies_on_bi_weekly(date)
    return false unless schedule["freq"] == EventableFrequency.bi_weekly

    week = ((date - starts_on).to_i / 7)
    week.even? ? schedule["days_in_week_one"].include?(date.cwday) : schedule["days_in_week_two"].include?(date.cwday)
  end

  def applies_on_monthly(date)
    return false unless schedule["freq"] == EventableFrequency.monthly

    (schedule["days_in_month"] || []).include?(date.day)
  end

  def applies_on_custom_dates(date)
    return false unless schedule["freq"] == EventableFrequency.custom_dates

    (schedule["custom_dates"] || []).map { |d| Date.parse(d) rescue nil }.compact.include?(date)
  end
end
