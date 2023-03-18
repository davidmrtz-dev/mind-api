require 'swagger_helper'

RSpec.describe 'api/v1/accounts', type: :request do
  path '/api/v1/accounts' do
    get('list accounts') do
      tags 'Accounts'
      consumes 'application/json'
      security ['access-token':[], client: [], uid: []]
      parameter name: 'access-token', in: :header, type: :string
      parameter name: 'client', in: :header, type: :string
      parameter name: 'uid', in: :header, type: :string

      response '200', 'Accounts Retrieved' do
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

    post('create account') do
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

      response '201', 'Account Created' do
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
    # You'll want to customize the parameter types...
    parameter name: 'id', in: :path, type: :string, description: 'id'

    get('show account') do
      response(200, 'successful') do
        let(:id) { '123' }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end

    patch('update account') do
      response(200, 'successful') do
        let(:id) { '123' }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end

    put('update account') do
      response(200, 'successful') do
        let(:id) { '123' }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end

    delete('delete account') do
      response(200, 'successful') do
        let(:id) { '123' }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end
  end
end
