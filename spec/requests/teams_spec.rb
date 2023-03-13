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
end