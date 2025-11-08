require 'rails_helper'

describe "WeightUnits" do
  describe '.all' do
    it 'returns all weight units' do
      expect(WeightUnits.all).to contain_exactly(
        WeightUnits.grams,
        WeightUnits.kilograms,
        WeightUnits.ounces,
        WeightUnits.pounds,
        WeightUnits.stones,
      )
    end
  end
end
