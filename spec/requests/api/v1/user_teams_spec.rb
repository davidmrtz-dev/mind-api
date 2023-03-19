require 'swagger_helper'

RSpec.describe 'api/v1/user_teams', type: :request do

  path '/api/v1/user_teams' do
    get('Retrieves user_teams') do
      tags 'UserTeams'
      consumes 'application/json'
      security ['access-token':[], client: [], uid: []]
      parameter name: 'access-token', in: :header, type: :string
      parameter name: 'client', in: :header, type: :string
      parameter name: 'uid', in: :header, type: :string

      response '200', 'Teams retrieved' do
        let!(:account) { AccountFactory.create }
        let!(:team) { TeamFactory.create(account: account) }
        let!(:user) { UserFactory.create }
        let!(:user_team) { UserTeamFactory.create(user: user, team: team) }
        let!(:admin) { UserFactory.create(user_type: :admin) }
        let!(:hdrs) { admin.create_new_auth_token }
        let(:'access-token') { hdrs['access-token'] }
        let(:client) { hdrs['client']}
        let(:uid) { hdrs['uid'] }

        run_test! do |response|
          expect(response).to have_http_status(:ok)
          expect(parsed_response[:user_teams].first[:id]).to eq user_team.id
        end
      end
    end

    post('Creates user_team') do
      tags 'UserTeams'
      consumes 'application/json'
      security ['access-token':[], client: [], uid: []]
      parameter name: 'access-token', in: :header, type: :string
      parameter name: 'client', in: :header, type: :string
      parameter name: 'uid', in: :header, type: :string

      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          user_team: {
            type: :object,
            properties: {
              user_id: { type: :number },
              team_id: { type: :number },
              start_at: { type: :string },
              end_at: { type: :string },
              status: { type: :string }
            },
            required: %w(user_id team_id start_at end_at status)
          }
        },
        required: %(user_team)
      }

      response '201', 'Team created' do
        let!(:account) { AccountFactory.create }
        let!(:team) { TeamFactory.create(account: account) }
        let!(:user) { UserFactory.create }
        let!(:admin) { UserFactory.create(user_type: :admin) }
        let!(:hdrs) { admin.create_new_auth_token }
        let(:'access-token') { hdrs['access-token'] }
        let(:client) { hdrs['client']}
        let(:uid) { hdrs['uid'] }

        let!(:params) do
          {
            user_team: {
              user_id: user.id,
              team_id: team.id,
              start_at: Time.zone.today,
              end_at: Time.zone.tomorrow,
              status: 'active'
            }
          }
        end

        run_test! do |response|
          expect(response).to have_http_status(:created)
          expect(parsed_response[:user_team][:id]).to eq UserTeam.first.id
        end
      end
    end
  end

  path '/api/v1/user_teams/{id}' do
    # You'll want to customize the parameter types...
    parameter name: 'id', in: :path, type: :string, description: 'id'

    patch('update user_team') do
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

    put('update user_team') do
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

    delete('delete user_team') do
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
