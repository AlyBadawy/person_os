require 'rails_helper'

RSpec.describe "Dashboard", type: :request do
  it "returns http success" do
  user = create(:user)
  sign_in(user, scope: :user)

    get '/'
    expect(response).to have_http_status(:ok)
  end

  it "renders the index template" do
  user = create(:user)
  sign_in(user, scope: :user)
    get "/"
    expect(response).to render_template(:index)
  end

  it "returns a 200 status code" do
  user = create(:user)
  sign_in(user, scope: :user)
    get "/"
    expect(response.status).to eq(200)
  end
end
