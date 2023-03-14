require 'rails_helper'

RSpec.describe Api::AccountsController, type: :controller do
  describe 'GET /api/accounts' do
    login_user

    it 'returns the accounts' do
      3.times { AccountFactory.create }
      get :index

      expect(response).to have_http_status(:ok)
      expect(parsed_response[:accounts].map { |a| a[:id] }).to match_array(Account.ids)
    end
  end

  describe 'GET /api/accounts/:id' do
    let(:account) { AccountFactory.create }

    login_user

    it 'returns an account' do
      get :show, params: { id: account.id }

      expect(response).to have_http_status(:ok)
      expect(parsed_response[:account][:id]).to eq account.id
    end
  end

  describe 'POST /api/accounts' do
    subject(:action) {
      post :create, params: {
        account: {
          client_name: 'Bart Simpson',
          manager_name: 'Darth Vader',
          name: 'Maze Runners'
        }
      }
    }

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

  describe 'PUT /api/accounts/:id' do
    let(:account) { AccountFactory.create(manager_name: nil) }

    subject(:action) {
      put :update, params: {
        id: account.id,
        account: {
          manager_name: 'Obi Wan Kenobi',
          name: 'The Dorilocos'
        }
      }
    }

    login_user

    it 'calls to update the account' do
      expect(account.manager_name).to eq nil

      action

      account.reload

      expect(response).to have_http_status(:ok)
      expect(parsed_response[:account][:id]).to eq account.id
      expect(account.manager_name).to eq 'Obi Wan Kenobi'
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

  describe 'DELETE /api/accounts/:id' do
    let!(:account) { AccountFactory.create }

    subject(:action) { delete :destroy, params: { id: account.id } }

    login_user

    it 'calls to delete the account' do
      expect { action }.to change { Account.count }.by (-1)

      action

      expect(response).to have_http_status(:no_content)
    end

    it 'handles not found' do
      expect { delete :destroy, params: { id: 0 } }
        .to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end