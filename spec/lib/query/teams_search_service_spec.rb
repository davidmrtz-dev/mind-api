require 'rails_helper'
require 'query/teams_search_service'

describe Query::TeamSearchService do
  let!(:today) { Time.zone.today }
  let(:user) { UserFactory.create(password: 'password') }
  let(:account) { AccountFactory.create }
  let!(:team_a) { TeamFactory.create(account: account, name: 'Lincers') }
  let!(:team_b) { TeamFactory.create(account: account, name: 'Alligators') }

  context 'when params are not valid' do
    it 'should raise an error' do
      expect do
        described_class.for(user, {
          keyword: 'Foxes',
          start_at: today.days_ago(2).to_s,
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
        expect(result.first.id).to team_a.name
      end
    end
  end
end