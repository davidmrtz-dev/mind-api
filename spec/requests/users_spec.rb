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

  xdescribe 'GET /api/user/:id' do
    login_user

    it 'returns a user' do
      get :show, params: { id: 0 }

      expect(response).to have_http_status(:ok)
      expect(parsed_response[:user][:id]).to eq 0
    end
  end
end