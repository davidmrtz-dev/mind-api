require 'rails_helper'

RSpec.describe Profile, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { should define_enum_for(:english_level).with_values(%i[a1 a2 b1 b2 c1 c2]) }
    it { should validate_presence_of(:english_level) }
    it { should validate_presence_of(:technical_knowledge) }
  end
end
