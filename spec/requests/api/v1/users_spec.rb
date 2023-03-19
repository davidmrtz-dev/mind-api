require 'swagger_helper'

RSpec.describe 'api/v1/users', type: :request do
  path '/api/v1/users' do
    get('Retrieves a list of users') do
      tags 'Users'
      consumes 'application/json'
      security ['access-token':[], client: [], uid: []]
      parameter name: 'access-token', in: :header, type: :string
      parameter name: 'client', in: :header, type: :string
      parameter name: 'uid', in: :header, type: :string

      response '200', 'Users retrieved' do
        let!(:standard_user) { UserFactory.create }
        let!(:admin) { UserFactory.create(user_type: :admin) }
        let!(:hdrs) { admin.create_new_auth_token }
        let(:'access-token') { hdrs['access-token'] }
        let(:client) { hdrs['client']}
        let(:uid) { hdrs['uid'] }

        run_test! do |response|
          expect(response).to have_http_status(:ok)
          expect(parsed_response[:users].first[:id]).to eq standard_user.id
        end
      end
    end

    post('Creates a user') do
      tags 'Users'
      consumes 'application/json'
      security ['access-token':[], client: [], uid: []]
      parameter name: 'access-token', in: :header, type: :string
      parameter name: 'client', in: :header, type: :string
      parameter name: 'uid', in: :header, type: :string

      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              name: { type: :string },
              email: { type: :string },
              password: { type: :string },
              password_confirmation: { type: :string },
              user_type: { type: :string }
            },
            required: %w(name email password)
          }
        },
        required: %(user)
      }

      response '201', 'User created' do
        let!(:admin) { UserFactory.create(user_type: :admin) }
        let!(:hdrs) { admin.create_new_auth_token }
        let(:'access-token') { hdrs['access-token'] }
        let(:client) { hdrs['client']}
        let(:uid) { hdrs['uid'] }
        let!(:params) do
          {
            user: {
              name: 'Mickey Mouse',
              email: 'mickey@example.com',
              password: 'password',
              password_confirmation: 'password',
              user_type: 'standard'
            }
          }
        end

        run_test! do |response|
          expect(response).to have_http_status(:created)
          expect(parsed_response[:user][:id]).to eq User.first.id
        end
      end
    end
  end

  path '/api/v1/users/{id}' do
    get('Retrieves a user') do
      tags 'Users'
      consumes 'application/json'
      security ['access-token':[], client: [], uid: []]
      parameter name: 'id', in: :path, type: :string, description: 'id'
      parameter name: 'access-token', in: :header, type: :string
      parameter name: 'client', in: :header, type: :string
      parameter name: 'uid', in: :header, type: :string

      response '200', 'User retrieved' do
        let!(:user) { UserFactory.create }
        let!(:admin) { UserFactory.create(user_type: :admin) }
        let!(:hdrs) { admin.create_new_auth_token }
        let(:'access-token') { hdrs['access-token'] }
        let(:client) { hdrs['client']}
        let(:uid) { hdrs['uid'] }
        let(:id) { user.id }

        run_test! do |response|
          expect(response).to have_http_status(:ok)
          expect(parsed_response[:user][:id]).to eq user.id
        end
      end
    end

    put('Updates a user') do
      tags 'Users'
      consumes 'application/json'
      security ['access-token':[], client: [], uid: []]
      parameter name: 'id', in: :path, type: :string, description: 'id'
      parameter name: 'access-token', in: :header, type: :string
      parameter name: 'client', in: :header, type: :string
      parameter name: 'uid', in: :header, type: :string

      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              name: { type: :string },
              email: { type: :string },
              user_type: { type: :string }
            },
            required: %w(name email password)
          }
        },
        required: %(user)
      }

      response '200', 'User updated' do
        let!(:user) { UserFactory.create }
        let!(:admin) { UserFactory.create(user_type: :admin) }
        let!(:hdrs) { admin.create_new_auth_token }
        let(:'access-token') { hdrs['access-token'] }
        let(:client) { hdrs['client']}
        let(:uid) { hdrs['uid'] }
        let(:id) { user.id }

        let!(:params) do
          {
            user: {
              name: 'Albert Einstein',
              email: 'albert@example.com',
              user_type: 'admin'
            }
          }
        end

        run_test! do |response|
          expect(response).to have_http_status(:ok)
          expect(parsed_response[:user][:id]).to eq user.id
          expect(parsed_response[:user][:name]).to eq 'Albert Einstein'
          expect(parsed_response[:user][:email]).to eq 'albert@example.com'
          expect(parsed_response[:user][:user_type]).to eq 'admin'
        end
      end
    end

    delete('Deletes a user') do
      tags 'Users'
      consumes 'application/json'
      security ['access-token':[], client: [], uid: []]
      parameter name: 'id', in: :path, type: :string, description: 'id'
      parameter name: 'access-token', in: :header, type: :string
      parameter name: 'client', in: :header, type: :string
      parameter name: 'uid', in: :header, type: :string

      response '204', 'User deleted' do
        let!(:user) { UserFactory.create }
        let!(:admin) { UserFactory.create(user_type: :admin) }
        let!(:hdrs) { admin.create_new_auth_token }
        let(:'access-token') { hdrs['access-token'] }
        let(:client) { hdrs['client']}
        let(:uid) { hdrs['uid'] }
        let(:id) { user.id }

        run_test! do |response|
          expect(response).to have_http_status(:no_content)
        end
      end
    end
  end
end
