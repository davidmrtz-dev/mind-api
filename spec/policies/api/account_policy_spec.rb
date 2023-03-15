require 'rails_helper'

RSpec.describe Api::AccountPolicy, type: :policy do
  context 'when user is standard' do
    let(:account) { AccountFactory.create }
    let(:user) { UserFactory.create(password: 'password') }
    let(:context) { { user: user } }
    let(:account_policy) { described_class.new(account, context) }

    shared_examples_for 'not authorized standard user' do
      it 'return false when user is standard' do
        is_expected.to be_falsey
      end
    end

    describe '#index' do
      subject { account_policy.apply(:index?) }

      include_examples 'not authorized standard user'
    end
  end
end