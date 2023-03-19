require 'swagger_helper'

RSpec.describe 'api/v1/teams', type: :request do
  path '/api/v1/teams' do
    get('Retrieves teams') do
      tags 'Teams'
      consumes 'application/json'
      security ['access-token':[], client: [], uid: []]
      parameter name: 'access-token', in: :header, type: :string
      parameter name: 'client', in: :header, type: :string
      parameter name: 'uid', in: :header, type: :string

      response '200', 'Teams retrieved' do
        let!(:account) { AccountFactory.create }
        let!(:team) { TeamFactory.create(account: account) }
        let!(:admin) { UserFactory.create(user_type: :admin) }
        let!(:hdrs) { admin.create_new_auth_token }
        let(:'access-token') { hdrs['access-token'] }
        let(:client) { hdrs['client']}
        let(:uid) { hdrs['uid'] }

        run_test! do |response|
          expect(response).to have_http_status(:ok)
          expect(parsed_response[:teams].first[:id]).to eq team.id
        end
      end
    end

    post('Creates team') do
      tags 'Teams'
      consumes 'application/json'
      security ['access-token':[], client: [], uid: []]
      parameter name: 'access-token', in: :header, type: :string
      parameter name: 'client', in: :header, type: :string
      parameter name: 'uid', in: :header, type: :string

      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          team: {
            type: :object,
            properties: {
              account_id: { type: :number },
              name: { type: :string }
            },
            required: %w(account_id name)
          }
        },
        required: %(team)
      }

      response '201', 'Team created' do
        let!(:account) { AccountFactory.create }
        let!(:admin) { UserFactory.create(user_type: :admin) }
        let!(:hdrs) { admin.create_new_auth_token }
        let(:'access-token') { hdrs['access-token'] }
        let(:client) { hdrs['client']}
        let(:uid) { hdrs['uid'] }

        let!(:params) do
          {
            team: {
              account_id: account.id,
              name: 'Maze Runners',
            }
          }
        end

        run_test! do |response|
          expect(response).to have_http_status(:created)
          expect(parsed_response[:team][:id]).to eq Team.first.id
        end
      end
    end
  end

  path '/api/v1/teams/{id}' do
    get('Retrieves a team') do
      tags 'Teams'
      consumes 'application/json'
      security ['access-token':[], client: [], uid: []]
      parameter name: 'id', in: :path, type: :string, description: 'id'
      parameter name: 'access-token', in: :header, type: :string
      parameter name: 'client', in: :header, type: :string
      parameter name: 'uid', in: :header, type: :string

      response '200', 'Team retrieved' do
        let!(:account) { AccountFactory.create }
        let!(:team) { TeamFactory.create(account: account) }
        let!(:admin) { UserFactory.create(user_type: :admin) }
        let!(:hdrs) { admin.create_new_auth_token }
        let(:'access-token') { hdrs['access-token'] }
        let(:client) { hdrs['client']}
        let(:uid) { hdrs['uid'] }
        let(:id) { account.id }

        run_test! do |response|
          expect(response).to have_http_status(:ok)
          expect(parsed_response[:team][:id]).to eq team.id
        end
      end
    end

    put('Updates a team') do
      tags 'Teams'
      consumes 'application/json'
      security ['access-token':[], client: [], uid: []]
      parameter name: 'id', in: :path, type: :string, description: 'id'
      parameter name: 'access-token', in: :header, type: :string
      parameter name: 'client', in: :header, type: :string
      parameter name: 'uid', in: :header, type: :string

      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          team: {
            type: :object,
            properties: {
              name: { type: :string }
            },
            required: %w(name)
          }
        },
        required: %(team)
      }

      response '200', 'Team updated' do
        let!(:account) { AccountFactory.create }
        let!(:team) { TeamFactory.create(account: account) }
        let!(:admin) { UserFactory.create(user_type: :admin) }
        let!(:hdrs) { admin.create_new_auth_token }
        let(:'access-token') { hdrs['access-token'] }
        let(:client) { hdrs['client']}
        let(:uid) { hdrs['uid'] }
        let(:id) { team.id }
        let!(:params) do
          {
            team: {
              name: 'Another name',
            }
          }
        end

        run_test! do |response|
          expect(response).to have_http_status(:ok)
          expect(parsed_response[:team][:id]).to eq team.id
          expect(parsed_response[:team][:name]).to eq 'Another name'
        end
      end
    end

    delete('Deletes a team') do
      tags 'Teams'
      consumes 'application/json'
      security ['access-token':[], client: [], uid: []]
      parameter name: 'id', in: :path, type: :string, description: 'id'
      parameter name: 'access-token', in: :header, type: :string
      parameter name: 'client', in: :header, type: :string
      parameter name: 'uid', in: :header, type: :string

      response '204', 'Account deleted' do
        let!(:account) { AccountFactory.create }
        let!(:team) { TeamFactory.create(account: account) }
        let!(:admin) { UserFactory.create(user_type: :admin) }
        let!(:hdrs) { admin.create_new_auth_token }
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
