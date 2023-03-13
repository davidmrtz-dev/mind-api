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
end