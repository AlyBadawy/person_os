require 'rails_helper'

RSpec.describe User, type: :model do
    describe 'factory' do
    it 'has a valid factory' do
      user = build(:user)
      expect(user).to be_valid
    end

    describe 'traits' do
      it 'confirmed trait sets confirmed_at' do
        user = create(:user, :confirmed)
        expect(user.confirmed_at).to be_present
      end

      it 'locked trait sets locked_at and failed_attempts' do
        user = create(:user, :locked)
        expect(user.locked_at).to be_present
        expect(user.failed_attempts).to be >= 1
      end

      it 'with_reset_token trait sets reset token and sent at' do
        user = create(:user, :with_reset_token)
        expect(user.reset_password_token).to be_present
        expect(user.reset_password_sent_at).to be_present
      end
    end
  end

  describe 'validations' do
    it 'validates uniqueness of email' do
      existing = create(:user)
      duplicate = build(:user, email: existing.email)

      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:email]).to include(a_string_including('has already been taken').or(a_string_including('taken')))
    end
  end

  describe 'devise validations' do
    it 'validates presence of email' do
      user = build(:user, email: nil)
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include(a_string_including("can't be blank").or(a_string_including('is invalid')))
    end

    it 'validates email format' do
      user = build(:user, email: 'not-an-email')
      expect(user).not_to be_valid
      expect(user.errors[:email]).to be_present
    end

    it 'validates presence of password on create' do
      user = build(:user, password: nil)
      expect(user).not_to be_valid
      expect(user.errors[:password]).to be_present
    end

    it 'enforces minimum password length' do
      short = 'a' * (Devise.password_length.first - 1)
      user = build(:user, password: short, password_confirmation: short)
      expect(user).not_to be_valid
      expect(user.errors[:password]).to be_present
    end

    it 'authenticates with valid password' do
      user = create(:user)
      expect(user.valid_password?('Password123!')).to be true
    end
  end

  describe 'callbacks' do
    skip 'add tests for any custom callbacks if present'
  end

  describe 'associations' do
    skip 'add tests for any associations if present'
  end
end
