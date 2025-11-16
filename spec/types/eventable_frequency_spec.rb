require 'rails_helper'

describe "EventableFrequency" do
  describe '.all' do
    it 'returns all event frequencies' do
      expect(EventableFrequency.all).to contain_exactly(
        EventableFrequency.none,
        EventableFrequency.once,
        EventableFrequency.daily,
        EventableFrequency.weekly,
        EventableFrequency.bi_weekly,
        EventableFrequency.monthly,
        EventableFrequency.custom_dates,
      )
    end
  end
end
