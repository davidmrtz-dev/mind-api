require 'rails_helper'

RSpec.describe UserTeam, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:team) }
  end

  describe 'validations' do
    let!(:user) { UserFactory.create(password: 'password') }
    let!(:account) { AccountFactory.create }
    let!(:team) { TeamFactory.create(account: account) }

    it 'should not allow an end_date before today' do
      user_team = UserTeam.new(user: user, team: team, status: :inactive, end_at: Time.zone.now - 5.days)
      expect(user_team.valid?).to be_falsey
      expect(user_team.errors.full_messages).to include('End date cannot be before today')
    end
  end
end
