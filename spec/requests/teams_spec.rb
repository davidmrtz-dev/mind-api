require 'rails_helper'

RSpec.describe Api::TeamsController, type: :controller do
  describe 'GET /api/teams' do
    login_user

    it 'returns the accounts' do
      get :index

      expect(response).to have_http_status(:ok)
      expect(parsed_response[:teams].map { |t| t[:id] }).to match_array(Team.ids)
    end
  end

  describe 'GET /api/teams/:id' do
    let(:account) { AccountFactory.create }
    let(:team) { TeamFactory.create(account: account) }

    login_user

    it 'returns an account' do
      get :show, params: { id: team.id }

      expect(response).to have_http_status(:ok)
      expect(parsed_response[:team][:id]).to eq team.id
    end
  end

  describe 'POST /api/teams' do
    let(:account) { AccountFactory.create }

    subject(:action) {
      post :create, params: {
        team: {
          account_id: account.id,
          name: 'Maze Runners'
        }
      }
    }

    login_user

    it 'creates and return a team' do
      expect { action }.to change { Team.count }.by 1

      action

      team = Team.last

      expect(response).to have_http_status(:created)
      expect(parsed_response[:team][:id]).to eq team.id
      expect(parsed_response[:team][:name]).to eq 'Maze Runners'
      expect(team.account_id).to eq account.id
    end
  end
end