require 'rails_helper'

RSpec.describe Api::UsersController, type: :controller do
  describe 'GET /api/users' do
    login_user

    it 'return users' do
      get :index

      expect(response).to have_http_status(:ok)
      expect(parsed_response[:users].map { |u| u[:id] }).to match_array(User.ids)
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

  describe 'POST /api/users' do
    subject(:action) {
      post :create, params: {
        user: {
          email: 'user-2@example.com',
          password: 'password',
          password_confirmation: 'password'
        }
      }
    }

    login_user

    it 'creates a user' do
      expect { action }.to change { User.count }.by 1

      action

      user = User.last

      expect(response).to have_http_status(:created)
      expect(parsed_response[:user][:id]).to eq user.id
      expect(parsed_response[:user][:email]).to eq 'user-2@example.com'
    end

    it 'handles validation error' do
      post :create, params: {
        user: {
          email: nil
        }
      }

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'PUT /api/users/:id' do
    let!(:user) { UserFactory.create(email: 'user@example.com', password: 'password') }

    subject(:action) {
      put :update, params: {
        id: user.id,
        user: {
          nickname: 'Dart Vader'
        }
      }
    }

    login_user

    it 'calls to update the user' do
      expect(user.nickname).to eq nil

      action

      user.reload

      expect(response).to have_http_status(:ok)
      expect(parsed_response[:user][:id]).to eq user.id
      expect(user.nickname).to eq 'Dart Vader'
    end

    it 'handles validation error' do
      put :update, params: {
        id: user.id,
        user: {
          email: ''
        }
      }

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'DELETE /api/users/:id' do
    let!(:user) { UserFactory.create(email: 'user@example.com', password: 'password') }
    let!(:another_user) { UserFactory.create(email: 'user-2@example.com', password: 'password') }

    subject(:action) { delete :destroy, params: { id: another_user.id } }

    before(:each) do
      headers = user.create_new_auth_token
      request.headers['access-token'] = headers['access-token']
      request.headers['client'] = headers['client']
      request.headers['uid'] = headers['uid']
    end

    it 'calls to delete the user' do
      expect { action }.to change { User.count }.by (-1)

      action

      expect(response).to have_http_status(:no_content)
    end

    it 'handles not found' do
      expect { delete :destroy, params: { id: 0 } }
        .to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end