require 'rails_helper'

RSpec.describe Team, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:account) }
    it { is_expected.to have_many(:users).through(:user_teams) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
  end
end
