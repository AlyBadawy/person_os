require 'rails_helper'

RSpec.describe Eventable, type: :model do
  describe 'factory' do
    it 'has a valid factory' do
      eventable = build(:eventable)
      expect(eventable).to be_valid
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }

    it { is_expected.to validate_presence_of(:starts_on) }

    it 'validates uniqueness of name scoped to user and eventable type' do
      user = create(:user)
      eventable_type = create(:eventable_type)
      create(:eventable, name: 'Meeting', user: user, eventable_type: eventable_type)

      duplicate_eventable = build(:eventable, name: 'Meeting', user: user, eventable_type: eventable_type)
      expect(duplicate_eventable).not_to be_valid
      expect(duplicate_eventable.errors[:name]).to include('has already been taken')
    end

    it 'allows same name for different users or eventable types' do
      user1 = create(:user)
      user2 = create(:user)
      eventable_type1 = create(:eventable_type)
      eventable_type2 = create(:eventable_type)

      create(:eventable, name: 'Meeting', user: user1, eventable_type: eventable_type1)
      expect(build(:eventable, name: 'Meeting', user: user2, eventable_type: eventable_type1)).to be_valid
      expect(build(:eventable, name: 'Meeting', user: user1, eventable_type: eventable_type2)).to be_valid
    end

    it 'validates that ends_on is after starts_on' do
      eventable = build(:eventable, starts_on: Date.current, ends_on: Date.current - 2.days)
      expect(eventable).not_to be_valid
      expect(eventable.errors[:ends_on]).to include('must be after start')
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:eventable_type) }
  end

  describe '#require_schedule_keys' do
    it 'adds default schedule keys on save' do
      e = create(:eventable, schedule: nil)
      expect(e.schedule).to include('freq', 'days_in_week_one', 'days_in_week_two', 'custom_dates', 'multiple_per_day')
      expect(e.schedule['freq']).to eq(EventableFrequency.once)
    end

    it 'merges existing schedule with defaults' do
      custom_schedule = {
        "freq" => EventableFrequency.weekly,
        "days_in_week_one" => [1, 3, 5],
      }
      e = create(:eventable, schedule: custom_schedule)
      expect(e.schedule['freq']).to eq(EventableFrequency.weekly)
      expect(e.schedule['days_in_week_one']).to eq([1, 3, 5])
      expect(e.schedule).to include('days_in_week_two', 'custom_dates', 'multiple_per_day')
    end

    it 'handles empty multiple_per_day hash' do
      custom_schedule = {
        "freq" => EventableFrequency.daily,
        "multiple_per_day" => {},
      }
      e = create(:eventable, schedule: custom_schedule)
      expect(e.schedule['multiple_per_day']).to eq(0)
    end
  end


  describe '#applies_on?' do
    it 'returns false when inactive' do
      e = build(:eventable, active: false, starts_on: Time.zone.today)
      expect(e.applies_on?(Time.zone.today)).to be false
    end

    it 'returns false before starts_on' do
      e = build(:eventable, active: true, starts_on: Date.tomorrow)
      expect(e.applies_on?(Time.zone.today)).to be false
    end

    it 'returns false after ends_on when present' do
      e = build(:eventable, active: true, starts_on: Date.yesterday, ends_on: Date.yesterday)
      expect(e.applies_on?(Date.tomorrow)).to be false
    end

    it 'returns true for once frequency on starts_on' do
      e = build(:eventable, active: true, starts_on: Date.current, schedule: { "freq" => EventableFrequency.once })
      expect(e.applies_on?(Date.current)).to be true
    end

    it 'returns true for daily frequency within date range' do
      e = build(:eventable, active: true, starts_on: Date.yesterday, ends_on: Date.tomorrow, schedule: { "freq" => EventableFrequency.daily })
      expect(e.applies_on?(Date.current)).to be true
    end

    it 'returns true for weekly frequency on correct weekday' do
      e = build(:eventable, active: true, starts_on: Date.current - 7.days, ends_on: Date.current + 7.days,
                            schedule: { "freq" => EventableFrequency.weekly, "days_in_week_one" => [Date.current.cwday] })
      expect(e.applies_on?(Date.current)).to be true
    end

    it 'returns false for weekly frequency on incorrect weekday' do
      wrong_day = Date.current.cwday % 7 + 1
      e = build(:eventable, active: true, starts_on: Date.current - 7.days, ends_on: Date.current + 7.days,
                            schedule: { "freq" => EventableFrequency.weekly, "days_in_week_one" => [wrong_day] })
      expect(e.applies_on?(Date.current)).to be false
    end

    it 'returns true for bi-weekly frequency on correct week and weekday' do
      start_date = Date.current - 14.days
      e = build(
        :eventable,
        active: true,
        starts_on: start_date,
        ends_on: Date.current + 14.days,
        schedule: {
            "freq" => EventableFrequency.bi_weekly,
            "days_in_week_one" => [Date.current.cwday],
            "days_in_week_two" => [Date.current.cwday % 7 + 1],
          }
        )
      expect(e.applies_on?(Date.current)).to be true
      expect(e.applies_on?(Date.current + 8.days)).to be true
    end

    it 'returns false for bi-weekly frequency on incorrect week or weekday' do
      start_date = Date.current - 14.days
      wrong_day = Date.current.cwday % 7 + 1
      e = build(
        :eventable,
        active: true,
        starts_on: start_date,
        ends_on: Date.current + 14.days,
        schedule: {
          "freq" => EventableFrequency.bi_weekly,
          "days_in_week_one" => [wrong_day],
          "days_in_week_two" => [wrong_day],
          }
      )
      expect(e.applies_on?(Date.current)).to be false
    end

    it 'returns true for custom dates frequency on matching date' do
      custom_date = Date.current + 3.days
      e = build(
        :eventable,
        active: true,
        starts_on: Date.current - 1.day,
        ends_on: Date.current + 10.days,
        schedule: {
          "freq" => EventableFrequency.custom_dates,
          "custom_dates" => [custom_date.to_s],
          }
      )
      expect(e.applies_on?(custom_date)).to be true
    end

    it 'returns false for custom dates frequency on non-matching date' do
      custom_date = Date.current + 3.days
      e = build(
        :eventable,
        active: true,
        starts_on: Date.current - 1.day,
        ends_on: Date.current + 10.days,
        schedule: {
          "freq" => EventableFrequency.custom_dates,
          "custom_dates" => [custom_date.to_s],
        })
      expect(e.applies_on?(Date.current)).to be false
    end

    it 'returns true for monthly frequency on correct day of month' do
      day_of_month = Date.current.day
      e = build(
        :eventable,
        active: true,
        starts_on: Date.current - 30.days,
        ends_on: Date.current + 30.days,
        schedule: {
          "freq" => EventableFrequency.monthly,
          "days_in_month" => [day_of_month],
        })
      expect(e.applies_on?(Date.current)).to be true
    end

    it 'returns false for monthly frequency on incorrect day of month' do
      wrong_day = (Date.current.day % 28) + 1
      e = build(
        :eventable,
        active: true,
        starts_on: Date.current - 30.days,
        ends_on: Date.current + 30.days,
        schedule: {
          "freq" => EventableFrequency.monthly,
          "days_in_month" => [wrong_day],
        })
      expect(e.applies_on?(Date.current)).to be false
    end

    it 'returns false for none frequency' do
      e = build(
        :eventable,
        active: true,
        starts_on: Date.current - 1.day,
        ends_on: Date.current + 1.day,
        schedule: { "freq" => EventableFrequency.none })
      expect(e.applies_on?(Date.current)).to be false
    end
  end
end
