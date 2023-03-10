require 'rails_helper'

RSpec.describe Api::UsersController, type: :controller do
  describe 'GET /api/users' do
    it 'return users' do
      get :index

      expect(response).to have_http_status(:ok)
    end
  end
end