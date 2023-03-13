require 'rails_helper'

RSpec.describe Api::AccountsController, type: :controller do
  describe 'GET /api/accounts' do
    login_user

    it 'return accounts' do
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

    it 'creates an account' do
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
end