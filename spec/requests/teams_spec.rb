require 'rails_helper'

RSpec.describe Api::V1::TeamsController, type: :controller do
  let!(:admin) { UserFactory.create(password: 'password', user_type: :admin) }
  let(:account) { AccountFactory.create }

  describe 'GET /api/v1/teams' do
    login_user

    context 'when user_id parameter is not present' do
      before do
        3.times { TeamFactory.create(account: account) }
        get :index
      end

      it 'returns a succesfull response' do
        expect(response).to have_http_status(:success)
      end

      it 'returns paginated teams' do
        expect(parsed_response[:teams].pluck(:id)).to match_array(Team.ids)
      end
    end

    context 'when user_id parameter is present' do
      let!(:team_1) { TeamFactory.create(account: account) }
      let!(:team_2) { TeamFactory.create(account: account) }
      let!(:dev_1) { UserFactory.create(password: 'password') }
      let!(:dev_2) { UserFactory.create(password: 'password') }
      let!(:user_team_1) { UserTeamFactory.create(user: dev_1, team: team_1) }
      let!(:user_team_2) { UserTeamFactory.create(user: dev_2, team: team_2) }

      before { get :index, params: { user_id: dev_1.id } }

      it 'returns a successful response' do
        expect(response).to have_http_status(:success)
      end

      it 'returns only teams that do not have a relation with the given user' do
        expect(parsed_response[:teams].count).to eq(1)
        expect(parsed_response[:teams][0]['id']).to eq(team_2.id)
      end
    end
  end

  describe 'GET /api/v1/teams/:user_id' do
    let(:developer) { UserFactory.create(password: 'password') }
    let(:team_1) { TeamFactory.create(account: account, name: 'Alligators') }
    let(:team_2) { TeamFactory.create(account: account) }
    let!(:u_t_1) { UserTeamFactory.create(user: developer, team: team_1) }
    let!(:u_t_2) { UserTeamFactory.create(user: developer, team: team_2) }

    login_user

    context 'when search params are not included' do
      before { get :show, params: { user_id: developer.id } }

      it 'returns a list of teams related to a user' do
        expect(response).to have_http_status(:ok)
        expect(parsed_response[:teams].map { |t| t[:id] })
          .to match_array([team_1.id, team_2.id])
      end

      it 'includes user_team data' do
        expect(response).to have_http_status(:ok)
        expect(parsed_response[:teams].map { |t| t[:user_team][:id] })
          .to match_array([u_t_1.id, u_t_2.id])
      end
    end

    context 'when search params are included' do
      before do
        get :show, params: {
          user_id: developer.id,
          keyword: 'Alligators',
          start_at: '',
          end_at: ''
        }
      end

      it 'returns a list of filteres teams related to a user' do
        expect(response).to have_http_status(:ok)
        expect(parsed_response[:teams].map { |t| t[:id]})
          .to match_array([team_1.id])
      end

      it 'includes user_team data' do
        expect(response).to have_http_status(:ok)
        expect(parsed_response[:teams].map { |t| t[:user_team][:id] })
          .to match_array([u_t_1.id])
      end
    end
  end

  describe 'POST /api/v1/teams' do
    subject(:action) do
      post :create, params: {
        team: {
          account_id: account.id,
          name: 'Maze Runners'
        }
      }
    end

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

  describe 'PUT /api/v1/teams/:id' do
    let(:team) { TeamFactory.create(account: account, name: 'Maze Runners') }

    subject(:action) do
      put :update, params: {
        id: team.id,
        team: {
          name: 'Falcons'
        }
      }
    end

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

  describe 'DELETE /api/v1/teams/:id' do
    let!(:team) { TeamFactory.create(account: account) }

    subject(:action) { delete :destroy, params: { id: team.id } }

    login_user

    it 'calls to delete the team' do
      expect { action }.to change { Team.count }.by(-1)

      action

      expect(response).to have_http_status(:no_content)
    end

    it 'handles not found' do
      expect { delete :destroy, params: { id: 0 } }
        .to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
