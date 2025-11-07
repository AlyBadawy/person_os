require 'rails_helper'

RSpec.describe 'Routing', type: :routing do
  it 'routes health check' do
    expect(get: '/up').to route_to(controller: 'rails/health', action: 'show')
  end

  it 'routes new user session (sign in)' do
    expect(get: '/users/sign_in').to route_to('devise/sessions#new')
  end

  it 'routes create user session' do
    expect(post: '/users/sign_in').to route_to('devise/sessions#create')
  end

  it 'routes destroy user session (sign out)' do
    expect(delete: '/users/sign_out').to route_to('devise/sessions#destroy')
  end

  it 'routes new user registration (sign up)' do
    expect(get: '/users/sign_up').to route_to('devise/registrations#new')
  end
end
