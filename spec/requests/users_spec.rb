require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  let!(:user) { UserFactory.create(password: 'password', user_type: :admin) }

  describe 'GET /api/users' do
    login_user

    it 'return users' do
      3.times do
        UserFactory.create(password: 'password')
      end

      get :index

      expect(response).to have_http_status(:ok)
      expect(parsed_response[:users].pluck(:id))
        .to match_array(User.where.not(id: user.id).ids)
    end
  end

  describe 'GET /api/users/:id' do
    let!(:user) { UserFactory.create(email: 'user@example.com', password: 'password') }
    let!(:profile) { ProfileFactory.create(user: user) }

    login_user

    it 'returns a user' do
      get :show, params: { id: user.id }

      expect(response).to have_http_status(:ok)
      expect(parsed_response[:user][:id]).to eq user.id
      expect(parsed_response[:user][:profile][:english_level]).to eq 'a1'
      expect(parsed_response[:user][:profile][:technical_knowledge]).to eq 'Docker'
    end
  end

  describe 'POST /api/users' do
    subject(:action) do
      post :create, params: {
        user: {
          name: 'Alfonso',
          email: 'user-2@example.com',
          password: 'password',
          password_confirmation: 'password',
          profile_attributes: {
            english_level: 'c1',
            technical_knowledge: 'AWS, Docker, React',
            cv: 'A link to my CV'
          }
        }
      }
    end

    login_user

    it 'creates a user' do
      expect { action }.to change { User.count }.by 1

      action

      user = User.first

      expect(response).to have_http_status(:created)
      expect(parsed_response[:user][:id]).to eq user.id
      expect(parsed_response[:user][:email]).to eq 'user-2@example.com'
      expect(parsed_response[:user][:profile][:english_level]).to eq 'c1'
      expect(parsed_response[:user][:profile][:technical_knowledge]).to eq 'AWS, Docker, React'
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
    let!(:admin) { UserFactory.create(password: 'password', user_type: :admin) }
    let!(:user) { UserFactory.create(password: 'password') }

    subject(:action) do
      put :update, params: {
        id: user.id,
        user: {
          name: 'Darth Vader'
        }
      }
    end

    login_user

    it 'calls to update the user' do
      expect(user.nickname).to eq nil

      action

      user.reload

      expect(response).to have_http_status(:ok)
      expect(parsed_response[:user][:id]).to eq user.id
      expect(user.name).to eq 'Darth Vader'
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
    let!(:admin) { UserFactory.create(password: 'password', user_type: :admin) }
    let!(:another_user) { UserFactory.create(password: 'password') }

    subject(:action) { delete :destroy, params: { id: another_user.id } }

    before(:each) do
      headers = admin.create_new_auth_token
      request.headers['access-token'] = headers['access-token']
      request.headers['client'] = headers['client']
      request.headers['uid'] = headers['uid']
    end

    it 'calls to delete the user' do
      expect { action }.to change { User.count }.by(-1)

      action

      expect(response).to have_http_status(:no_content)
    end

    it 'handles not found' do
      expect { delete :destroy, params: { id: 0 } }
        .to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'not allow self destroy' do
      expect { delete :destroy, params: { id: admin.id } }
        .to raise_error(Errors::SelfDestroy)
    end
  end
end
