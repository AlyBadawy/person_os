require 'rails_helper'

RSpec.describe EventableType, type: :model do
  describe 'factory' do
    it 'has a valid factory' do
      eventable_type = build(:eventable_type)
      expect(eventable_type).to be_valid
    end
  end

  describe 'validations' do
    it 'validates presence of name' do
      eventable_type = build(:eventable_type, name: nil)
      expect(eventable_type).not_to be_valid
      expect(eventable_type.errors[:name]).to include("can't be blank")
    end

    it 'validates uniqueness of name' do
      existing = create(:eventable_type)
      duplicate = build(:eventable_type, name: existing.name)

      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:name]).to include(a_string_including('has already been taken').or(a_string_including('taken')))
    end
  end
end
