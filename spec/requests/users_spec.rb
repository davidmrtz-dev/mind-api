require 'rails_helper'

RSpec.describe Api::UsersController, type: :controller do
  describe 'GET /api/users' do
    login_user

    it 'return users' do
      get :index

      expect(response).to have_http_status(:ok)
      expect(parsed_response[:users].map { |o| o[:id] }).to match_array(User.ids)
    end
  end

  describe 'GET /api/user/:id' do
    let!(:user) { UserFactory.create(email: 'user@example.com', password: 'password') }

    login_user

    it 'returns a user' do
      get :show, params: { id: user.id }

      expect(response).to have_http_status(:ok)
      expect(parsed_response[:user][:id]).to eq user.id
    end
  end
end