require 'rails_helper'

RSpec.describe "Api::Statuses", type: :request do
  describe "GET /" do
    it "returns http success" do
      sign_in FactoryBot.create(:user)
      get "/api/status"
      expect(response).to have_http_status(:success)
    end
  end
end
