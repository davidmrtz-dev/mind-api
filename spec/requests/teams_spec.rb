require 'rails_helper'

RSpec.describe Api::TeamsController, type: :controller do
  let(:account) { AccountFactory.create }

  describe 'GET /api/teams' do
    login_user

    it 'returns the accounts' do
      3.times { TeamFactory.create(account: account) }

      get :index

      expect(response).to have_http_status(:ok)
      expect(parsed_response[:teams].map { |t| t[:id] }).to match_array(Team.ids)
    end
  end

  describe 'GET /api/teams/:id' do
    let(:team) { TeamFactory.create(account: account) }

    login_user

    it 'returns an account' do
      get :show, params: { id: team.id }

      expect(response).to have_http_status(:ok)
      expect(parsed_response[:team][:id]).to eq team.id
    end
  end

  describe 'POST /api/teams' do
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

    it 'handles validation error' do
      post :create, params: {
        team: {
          account_id: account.id,
          name: nil
        }
      }

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'PUT /api/teams/:id' do
    let(:team) { TeamFactory.create(account: account, name: 'Maze Runners') }

    subject(:action) {
      put :update, params: {
        id: team.id,
        team: {
          name: 'Falcons'
        }
      }
    }

    login_user

    it 'calls to update the team' do
      expect(team.name).to eq 'Maze Runners'

      action

      team.reload

      expect(response).to have_http_status(:ok)
      expect(parsed_response[:team][:id]).to eq team.id
      expect(team.name).to eq 'Falcons'
    end

    it 'handles validation error' do
      put :update, params: {
        id: team.id,
        team: {
          name: nil
        }
      }

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'DELETE /api/teams/:id' do
    let!(:team) { TeamFactory.create(account: account) }

    subject(:action) { delete :destroy, params: { id: team.id } }

    login_user

    it 'calls to delete the team' do
      expect { action }.to change { Team.count }.by (-1)

      action

      expect(response).to have_http_status(:no_content)
    end

    it 'handles not found' do
      expect { delete :destroy, params: { id: 0 } }
        .to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end