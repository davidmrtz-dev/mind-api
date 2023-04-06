require 'rails_helper'
require 'query/teams_search_service'

describe Query::TeamSearchService do
  let(:user) { UserFactory.create(password: 'password') }
  let(:account) { AccountFactory.create }
  let!(:team_a) { TeamFactory.create(account: account, name: 'Lincers') }
  let!(:team_b) { TeamFactory.create(account: account, name: 'Alligators') }
  let!(:user_team_a) { UserTeamFactory.create(user: user, team: team_a, start_at: 2.days.ago, end_at: Time.zone.tomorrow)}
  let!(:user_team_b) { UserTeamFactory.create(user: user, team: team_b, start_at: 2.days.from_now, end_at: 5.days.from_now) }

  context 'when params are not valid' do
    it 'should raise an error' do
      expect do
        described_class.for(user, {
          keyword: 'Foxes',
          start_at: 2.days.ago.to_s,
          end_at: ''
        })
      end.to raise_error(Errors::InvalidParameters)
    end
  end

  context 'when params are valid' do
    describe 'when dates params are not provided but keyword' do
      it 'should return matching teams based on name' do
        result = described_class.for(Team.all, {
          keyword: team_a.name,
          start_at: '',
          end_at: ''
        })

        expect(result.count).to eq 1
        expect(result.first.id).to eq team_a.id
        expect(result.first.name).to eq team_a.name
      end
    end

    describe 'when dates params are provided but not keyword' do
      context 'when user_teams are included in active record relation' do
        it 'should return matching teams based on given dates' do
          result = described_class.for(user.teams.includes(:user_teams), {
            keyword: '',
            start_at: 2.days.ago.to_s,
            end_at: Time.zone.tomorrow.to_s
          })

          expect(result.count).to eq 1
          expect(result.first.id).to eq team_a.id
          expect(result.first.name).to eq team_a.name
        end
      end

      context 'when user_teams are not included in active record relation' do
        it 'should raise an error' do
          expect do
            described_class.for(Team.all, {
              keyword: '',
              start_at: 2.days.ago.to_s,
              end_at: Time.zone.tomorrow.to_s
            })
          end.to raise_error(Errors::MissingIncludedRecords)
        end
      end
    end

    describe 'when dates and keyword params are provided' do
      context 'when user_teams are included in active record relation' do
        it 'should return matching teams based on given dates and keyword' do
          result = described_class.for(user.teams.includes(:user_teams), {
            keyword: team_b.name,
            start_at: 2.days.from_now.to_s,
            end_at: 5.days.from_now.to_s
          })

          expect(result.count).to eq 1
          expect(result.first.id).to eq team_b.id
          expect(result.first.name).to eq team_b.name
        end
      end

      context 'when user_teams are not included in active record relation' do
        it 'should raise an erro' do
          expect do
            described_class.for(Team.all, {
              keyword: team_b.name,
              start_at: 2.days.from_now.to_s,
              end_at: 5.days.from_now.to_s
            })
          end.to raise_error(Errors::MissingIncludedRecords)
        end
      end
    end
  end
end