require 'rails_helper'

RSpec.describe Api::V1::UserTeamsController, type: :controller do
  let!(:user) { UserFactory.create(password: 'password') }
  let!(:account) { AccountFactory.create }
  let!(:team) { TeamFactory.create(account: account) }

  describe 'GET /api/user_teams' do
    login_user

    it 'returns the user teams realations' do
      3.times { UserTeamFactory.create(user: user, team: team, status: :active)  }

      get :index

      expect(response).to have_http_status(:ok)
      expect(parsed_response[:user_teams].map { |u| u[:id] }).to match_array(UserTeam.ids)
    end
  end

  describe 'POST /api/user_teams' do
    subject(:action) {
      post :create, params: {
        user_team: {
          user_id: user.id,
          team_id: team.id,
          start_at: Date.today,
          end_date: Date.tomorrow,
          status: 'active'
        }
      }
    }

    login_user

    it 'creates and return a user_team' do
      expect { action }.to change { UserTeam.count }.by 1

      action

      user_team = UserTeam.last

      expect(response).to have_http_status(:created)
      expect(parsed_response[:user_team][:id]).to eq user_team.id
      expect(parsed_response[:user_team][:user_id]).to eq user.id
      expect(parsed_response[:user_team][:team_id]).to eq team.id
    end

    it 'handles validation error' do
      post :create, params: {
        user_team: {
          user_id: user.id,
          team_id: team.id,
          status: nil
        }
      }

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'DELETE /api/user_teams/:id' do
    let!(:user_team) { UserTeamFactory.create(user: user, team: team) }

    subject(:action) { delete :destroy, params: { id: user_team.id } }

    login_user

    it 'calls to delete the user_team' do
      expect { action }.to change { UserTeam.count }.by (-1)

      action

      expect(response).to have_http_status(:no_content)
    end

    it 'handles not found' do
      expect { delete :destroy, params: { id: 0 } }
        .to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end