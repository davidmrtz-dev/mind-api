require 'rails_helper'

RSpec.describe Api::V1::UserTeamsController, type: :controller do
  let!(:user) { UserFactory.create(password: 'password', user_type: :admin) }
  let!(:account) { AccountFactory.create }
  let!(:team) { TeamFactory.create(account: account) }

  describe 'GET /api/user_teams' do
    login_user

    it 'returns the user_teams relations' do
      3.times { UserTeamFactory.create(user: user, team: team, status: :active) }

      get :index

      expect(response).to have_http_status(:ok)
      expect(parsed_response[:user_teams].pluck(:id)).to match_array(UserTeam.ids)
    end
  end

  describe 'POST /api/user_teams' do
    subject(:action) do
      post :create, params: {
        user_team: {
          user_id: user.id,
          team_id: team.id,
          start_at: Time.zone.today,
          end_at: Time.zone.tomorrow,
          status: 'active'
        }
      }
    end

    login_user

    it 'creates and return a user_team' do
      expect { action }.to change { UserTeam.count }.by 1

      action

      user_team = UserTeam.first

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

  describe 'PUT /api/user_teams/:id' do
    let!(:user_team) { UserTeamFactory.create(user: user, team: team, status: :active) }

    subject(:action) do
      put :update, params: {
        id: user_team.id,
        user_team: {
          status: 'inactive'
        }
      }
    end

    login_user

    it 'calls to update the user_team' do
      expect(user_team.status).to eq 'active'

      action

      user_team.reload

      expect(response).to have_http_status(:ok)
      expect(parsed_response[:user_team][:id]).to eq user_team.id
      expect(user_team.status).to eq 'inactive'
    end

    it 'handles validation error' do
      put :update, params: {
        id: user_team.id,
        user_team: {
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
      expect { action }.to change { UserTeam.count }.by(-1)

      action

      expect(response).to have_http_status(:no_content)
    end

    it 'handles not found' do
      expect { delete :destroy, params: { id: 0 } }
        .to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
