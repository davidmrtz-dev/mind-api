require 'rails_helper'

RSpec.describe Api::UserTeamsController, type: :controller do
  let(:user) { UserFactory.create(password: 'password') }
  let(:account) { AccountFactory.create }
  let(:team) { TeamFactory.create(account: account) }

  login_user

  it 'returns the user teams realations' do
    3.times { UserTeamFactory.create(user: user, team: team, status: :active)  }

    get :index

    expect(response).to have_http_status(:ok)
    expect(parsed_response[:user_teams].map { |u| u[:id] }).to match_array(UserTeam.ids)
  end
end