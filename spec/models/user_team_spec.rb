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

    it { should validate_presence_of(:start_at) }
    it { should validate_presence_of(:end_at) }
    it { should validate_presence_of(:status) }

    describe 'uniqueness' do
      context 'when a UserTeam record already exist for the same user and team' do
        before { UserTeamFactory.create(user: user, team: team) }

        it 'is invalid' do
          user_team = UserTeamFactory.build(user: user, team: team)
          expect(user_team).to be_invalid
          expect(user_team.errors[:user_id]).to include('has already been taken')
        end
      end

      context 'when a UserTeam record does not exists for the same user and team' do
        it 'is valid' do
          user_team = UserTeamFactory.build(user: user, team: team)
          expect(user_team).to be_valid
        end
      end
    end

    describe '#end_at_not_before_today' do
      it 'should not allow an end_date before today' do
        user_team = UserTeam.new(user: user, team: team, status: :inactive, end_at: 5.days.ago)
        expect(user_team.valid?).to be_falsey
        expect(user_team.errors.full_messages).to include('End date cannot be before today')
      end
    end
  end
end
