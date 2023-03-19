require 'swagger_helper'

RSpec.describe 'api/v1/accounts', type: :request do
  path '/api/v1/accounts' do
    get('Retrieves a list of accounts') do
      tags 'Accounts'
      consumes 'application/json'
      security ['access-token':[], client: [], uid: []]
      parameter name: 'access-token', in: :header, type: :string
      parameter name: 'client', in: :header, type: :string
      parameter name: 'uid', in: :header, type: :string

      response '200', 'Accounts retrieved' do
        let!(:account) { AccountFactory.create }
        let!(:user) { UserFactory.create(user_type: :admin) }
        let!(:hdrs) { user.create_new_auth_token }
        let(:'access-token') { hdrs['access-token'] }
        let(:client) { hdrs['client']}
        let(:uid) { hdrs['uid'] }

        run_test! do |response|
          expect(response).to have_http_status(:ok)
          expect(parsed_response[:accounts].first[:id]).to eq account.id
        end
      end
    end

    post('Creates an account') do
      tags 'Accounts'
      consumes 'application/json'
      security ['access-token':[], client: [], uid: []]
      parameter name: 'access-token', in: :header, type: :string
      parameter name: 'client', in: :header, type: :string
      parameter name: 'uid', in: :header, type: :string

      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          account: {
            type: :object,
            properties: {
              client_name: { type: :string },
              manager_name: { type: :string },
              name: { type: :string }
            },
            required: %w(name)
          }
        },
        required: %(account)
      }

      response '201', 'Account created' do
        let!(:user) { UserFactory.create(user_type: :admin) }
        let!(:hdrs) { user.create_new_auth_token }
        let(:'access-token') { hdrs['access-token'] }
        let(:client) { hdrs['client']}
        let(:uid) { hdrs['uid'] }

        let(:'client_name') { 'Elon Musk' }
        let(:manager_name) { 'Micky Mouse' }
        let(:name) { 'Obsidian' }
        let!(:params) do
          {
            account: {
              name: name,
              client_name: client_name,
              manager_name: manager_name
            }
          }
        end

        run_test! do |response|
          expect(response).to have_http_status(:created)
          expect(parsed_response[:account][:id]).to eq Account.first.id
        end
      end
    end
  end

  path '/api/v1/accounts/{id}' do
    get('Retrieves an account') do
      tags 'Accounts'
      consumes 'application/json'
      security ['access-token':[], client: [], uid: []]
      parameter name: 'id', in: :path, type: :string, description: 'id'
      parameter name: 'access-token', in: :header, type: :string
      parameter name: 'client', in: :header, type: :string
      parameter name: 'uid', in: :header, type: :string

      response '200', 'Account retrieved' do
        let!(:account) { AccountFactory.create }
        let!(:user) { UserFactory.create(user_type: :admin) }
        let!(:hdrs) { user.create_new_auth_token }
        let(:'access-token') { hdrs['access-token'] }
        let(:client) { hdrs['client']}
        let(:uid) { hdrs['uid'] }
        let(:id) { account.id }

        run_test! do |response|
          expect(response).to have_http_status(:ok)
          expect(parsed_response[:account][:id]).to eq account.id
        end
      end
    end

    put('Updates an account') do
      tags 'Accounts'
      consumes 'application/json'
      security ['access-token':[], client: [], uid: []]
      parameter name: 'id', in: :path, type: :string, description: 'id'
      parameter name: 'access-token', in: :header, type: :string
      parameter name: 'client', in: :header, type: :string
      parameter name: 'uid', in: :header, type: :string

      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          account: {
            type: :object,
            properties: {
              client_name: { type: :string },
              manager_name: { type: :string },
              name: { type: :string }
            },
            required: %w(name)
          }
        },
        required: %(account)
      }

      response '200', 'Account updated' do
        let!(:account) do
          AccountFactory.create(
            name: 'Account name',
            client_name: 'Client name',
            manager_name: 'Manager Name'
          )
        end
        let!(:user) { UserFactory.create(user_type: :admin) }
        let!(:hdrs) { user.create_new_auth_token }
        let(:'access-token') { hdrs['access-token'] }
        let(:client) { hdrs['client']}
        let(:uid) { hdrs['uid'] }
        let(:id) { account.id }

        let(:'client_name') { 'Elon Musk' }
        let(:manager_name) { 'Mickey Mouse' }
        let(:name) { 'Obsidian' }
        let!(:params) do
          {
            account: {
              name: name,
              client_name: client_name,
              manager_name: manager_name
            }
          }
        end

        run_test! do |response|
          expect(response).to have_http_status(:ok)
          expect(parsed_response[:account][:id]).to eq account.id
          expect(parsed_response[:account][:client_name]).to eq 'Elon Musk'
          expect(parsed_response[:account][:manager_name]).to eq 'Mickey Mouse'
          expect(parsed_response[:account][:name]).to eq 'Obsidian'
        end
      end
    end

    delete('Deletes an account') do
      tags 'Accounts'
      consumes 'application/json'
      security ['access-token':[], client: [], uid: []]
      parameter name: 'id', in: :path, type: :string, description: 'id'
      parameter name: 'access-token', in: :header, type: :string
      parameter name: 'client', in: :header, type: :string
      parameter name: 'uid', in: :header, type: :string

      response '204', 'Account deleted' do
        let!(:account) do
          AccountFactory.create(
            name: 'Account name',
            client_name: 'Client name',
            manager_name: 'Manager Name'
          )
        end
        let!(:user) { UserFactory.create(user_type: :admin) }
        let!(:hdrs) { user.create_new_auth_token }
        let(:'access-token') { hdrs['access-token'] }
        let(:client) { hdrs['client']}
        let(:uid) { hdrs['uid'] }
        let(:id) { account.id }

        run_test! do |response|
          expect(response).to have_http_status(:no_content)
        end
      end
    end
  end
end
