require 'rails_helper'
require 'query/teams_search_service'

describe Query::TeamSearchService do
  let!(:today) { Time.zone.today }
  let(:user) { UserFactory.create(password: 'password') }

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
end