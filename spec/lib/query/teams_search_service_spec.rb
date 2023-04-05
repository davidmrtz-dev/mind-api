require 'rails_helper'
require 'query/teams_search_service'

describe Query::TeamSearchService do
  it 'should return a string' do
    expect(described_class.for({})).to eq 'results'
  end
end