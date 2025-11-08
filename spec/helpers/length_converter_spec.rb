require "rails_helper"

RSpec.describe LengthConverter do
  describe ".cm_to_inches_and_feet" do
    it "converts 170 cm to 5 feet 7 inches" do
      expect(described_class.cm_to_inches_and_feet(170)).to eq({ feet: 5, inches: 7 })
    end

    it "handles zero cm" do
      expect(described_class.cm_to_inches_and_feet(0)).to eq({ feet: 0, inches: 0 })
    end

    it "handles exact one inch (2.54 cm)" do
      expect(described_class.cm_to_inches_and_feet(2.54)).to eq({ feet: 0, inches: 1 })
    end

    it "accepts numeric strings" do
      expect(described_class.cm_to_inches_and_feet("170")).to eq({ feet: 5, inches: 7 })
    end
  end

  describe ".inches_and_feet_to_cm" do
    it "converts 5 feet 7 inches to 170 cm (rounded)" do
      expect(described_class.inches_and_feet_to_cm(5, 7)).to eq(170)
    end

    it "handles fractional inches and rounds to nearest cm" do
      # 5 ft 6.5 in => 66.5 in * 2.54 = 168.91 => rounds to 169
      expect(described_class.inches_and_feet_to_cm(5, 6.5)).to eq(169)
    end

    it "accepts string inputs for feet and inches" do
      expect(described_class.inches_and_feet_to_cm("5", "7")).to eq(170)
    end
  end
end
