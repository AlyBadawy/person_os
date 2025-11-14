require 'rails_helper'

RSpec.describe FeaturesUser, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:feature) }
  end
end
