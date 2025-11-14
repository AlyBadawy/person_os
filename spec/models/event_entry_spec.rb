require 'rails_helper'

RSpec.describe EventEntry, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:eventable) }
    it { is_expected.to belong_to(:user) }
  end

  describe 'callbacks' do
    describe 'before_create :set_defaults' do
      let(:user) { create(:user) }
      let(:eventable) { create(:eventable, user: user) }

      it 'sets default metadata if not provided' do
        entry = described_class.new(eventable: eventable, user: user)
        entry.save!
        expect(entry.metadata).to eq({})
      end

      it 'sets occurred_at to current time if not provided' do
        entry = described_class.new(eventable: eventable, user: user)
        before_save_time = Time.current
        entry.save!
        expect(entry.occurred_at).to be_within(1.second).of(before_save_time)
      end
    end
  end

  describe 'validations' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    let(:eventable) { create(:eventable, user: user) }

    it 'is valid when eventable user matches entry user' do
      entry = described_class.new(eventable: eventable, user: user)
      expect(entry).to be_valid
    end

    it 'is invalid when eventable user does not match entry user' do
      entry = described_class.new(eventable: eventable, user: other_user)
      expect(entry).not_to be_valid
      expect(entry.errors[:user]).to include("must be the same as the eventable's user")
    end
  end
end
