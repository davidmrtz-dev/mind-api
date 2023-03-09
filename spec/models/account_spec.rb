require 'rails_helper'

RSpec.describe Account, type: :model do
  describe 'validations' do
    it { should allow_value('A client name').for(:client_name).on(:update) }
    it { should allow_value('Jhon Doe').for(:manager_name).on(:update) }
    it { should allow_value('Maze Runners').for(:name).on(:update) }
  end
end
