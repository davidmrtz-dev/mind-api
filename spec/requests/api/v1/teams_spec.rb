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

    post('create team') do
      response(200, 'successful') do

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

    patch('update team') do
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

    put('update team') do
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

    delete('delete team') do
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
