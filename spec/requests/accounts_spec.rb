require 'rails_helper'

RSpec.describe Api::V1::AccountsController, type: :controller do
  let!(:admin) { UserFactory.create(password: 'password', user_type: :admin) }

  describe 'GET /api/v1/accounts' do
    login_user

    it 'returns the accounts' do
      3.times { AccountFactory.create }
      get :index

      expect(response).to have_http_status(:ok)
      expect(parsed_response[:accounts].pluck(:id)).to match_array(Account.ids)
    end
  end

  describe 'GET /api/v1/accounts/:id' do
    let(:account) { AccountFactory.create }

    login_user

    it 'returns an account' do
      get :show, params: { id: account.id }

      expect(response).to have_http_status(:ok)
      expect(parsed_response[:account][:id]).to eq account.id
    end
  end

  describe 'POST /api/v1/accounts' do
    subject(:action) do
      post :create, params: {
        account: {
          client_name: 'Bart Simpson',
          manager_name: 'Darth Vader',
          name: 'Maze Runners'
        }
      }
    end

    login_user

    it 'creates and return an account' do
      expect { action }.to change { Account.count }.by 1

      action

      account = Account.last

      expect(response).to have_http_status(:created)
      expect(parsed_response[:account][:id]).to eq account.id
      expect(parsed_response[:account][:name]).to eq account.name
    end

    it 'handles validation error' do
      post :create, params: {
        account: {
          name: nil
        }
      }

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'PUT /api/v1/accounts/:id' do
    let(:account) { AccountFactory.create }

    subject(:action) do
      put :update, params: {
        id: account.id,
        account: {
          client_name: 'Skywalker',
          manager_name: 'Obi Wan Kenobi',
          name: 'The Dorilocos'
        }
      }
    end

    login_user

    it 'calls to update the account' do
      action

      account.reload

      expect(response).to have_http_status(:ok)
      expect(parsed_response[:account][:id]).to eq account.id
      expect(account.manager_name).to eq 'Obi Wan Kenobi'
      expect(account.client_name).to eq 'Skywalker'
    end

    it 'handles validation error' do
      put :update, params: {
        id: account.id,
        account: {
          name: nil
        }
      }

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'DELETE /api/v1/accounts/:id' do
    let!(:account) { AccountFactory.create }

    subject(:action) { delete :destroy, params: { id: account.id } }

    login_user

    it 'calls to delete the account' do
      expect { action }.to change { Account.count }.by(-1)

      action

      expect(response).to have_http_status(:no_content)
    end

    it 'handles not found' do
      expect { delete :destroy, params: { id: 0 } }
        .to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
