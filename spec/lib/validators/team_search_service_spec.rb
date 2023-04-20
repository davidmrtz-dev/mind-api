require 'rails_helper'
require 'query/teams_search_service'

describe Validators::TeamSearchService do
  describe '.valid_params?' do
    context 'when params are valid' do
      it 'should return truthy' do
        expect(described_class.valid_params?({
          keyword: 'test',
          start_at: '',
          end_at: ''
        })).to be_truthy
      end
    end

    context 'when params are not valid' do
      it 'should return falsey' do
        expect(described_class.valid_params?({
          keyword: 'test',
          start_at: 2.days.ago.to_s,
          end_at: ''
        })).to be_falsey
      end
    end
  end
end