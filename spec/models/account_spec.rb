require 'rails_helper'

RSpec.describe Account, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:teams).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:client_name) }
    it { should validate_presence_of(:manager_name) }
    it { should validate_presence_of(:name) }
  end
end
