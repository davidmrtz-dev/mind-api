require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { is_expected.to have_one(:profile).dependent(:destroy) }
    it { is_expected.to have_many(:teams).through(:user_teams) }
    it { should define_enum_for(:user_type).with_values(%i[standard admin super]) }
  end
end