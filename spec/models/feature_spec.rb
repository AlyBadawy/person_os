require 'rails_helper'

RSpec.describe Feature, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:features_users).dependent(:destroy) }
    it { is_expected.to have_many(:users).through(:features_users) }
  end
end
