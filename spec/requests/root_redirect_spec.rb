require 'rails_helper'

RSpec.describe 'Root', type: :request do
  it 'redirects unauthenticated root to sign in' do
    get '/'
    expect(response).to redirect_to('/users/sign_in')
  end

  it 'allows authenticated users to access authenticated root' do
  user = create(:user)
  sign_in(user, scope: :user)

  get '/'
  expect(response).to have_http_status(:ok)
  end
end
