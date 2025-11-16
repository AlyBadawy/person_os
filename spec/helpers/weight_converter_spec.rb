require "rails_helper"

RSpec.describe WeightConverter do
  describe ".convert_value" do
    it "converts the string value \"200\" for every unit combination" do # rubocop:disable RSpec/ExampleLength
        units = {
          grams: WeightUnits.grams,
          kilograms: WeightUnits.kilograms,
          ounces: WeightUnits.ounces,
          pounds: WeightUnits.pounds,
          stones: WeightUnits.stones,
        }

        # Precomputed expected results for value "200" (string) for every from->to combination
        expected = {
          grams: {
            grams: 200.0,
            kilograms: 0.2,
            ounces: 7.05,
            pounds: 0.44,
            stones: 0.03,
          },
          kilograms: {
            grams: 200000.0,
            kilograms: 200.0,
            ounces: 7054.80,
            pounds: 440.92,
            stones: 31.49,
          },
          ounces: {
            grams: 5669.9,
            kilograms: 5.67,
            ounces: 200.0,
            pounds: 12.5,
            stones: 0.89,
          },
          pounds: {
            grams: 90718.4,
            kilograms: 90.72,
            ounces: 3200.0,
            pounds: 200.0,
            stones: 14.29,
          },
          stones: {
            grams: 1270058.0,
            kilograms: 1270.06,
            ounces: 44800.01,
            pounds: 2800.0,
            stones: 200.0,
          },
        }
      units.each do |from_key, from_unit|
        units.each do |to_key, to_unit|
          expected_value = expected[from_key][to_key]
          result = described_class.convert_value("200", from_unit, to_unit)
          # Use eq for exact equality of numeric; convert both to floats for comparison
          expect(result).to eq(expected_value)
        end
      end
    end

    it "raises ArgumentError for unsupported from_unit" do
      expect {
        described_class.convert_value(100, "invalid_unit", WeightUnits.grams)
      }.to raise_error(ArgumentError, /Unsupported weight unit/)
    end

    it "raises ArgumentError for unsupported to_unit" do
      expect {
        described_class.convert_value(100, WeightUnits.grams, "invalid_unit")
      }.to raise_error(ArgumentError, /Unsupported weight unit/)
    end
  end
end
