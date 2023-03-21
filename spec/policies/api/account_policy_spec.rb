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

    describe '#index?' do
      subject { account_policy.apply(:index?) }

      include_examples 'not authorized standard user'
    end

    describe '#show?' do
      subject { account_policy.apply(:show?) }

      include_examples 'not authorized standard user'
    end

    describe '#create?' do
      subject { account_policy.apply(:create?) }

      include_examples 'not authorized standard user'
    end

    describe '#update?' do
      subject { account_policy.apply(:update?) }

      include_examples 'not authorized standard user'
    end

    describe '#destroy?' do
      subject { account_policy.apply(:destroy?) }

      include_examples 'not authorized standard user'
    end
  end

  context 'when user is admin' do
    let(:account) { AccountFactory.create }
    let(:user) { UserFactory.create(password: 'password', user_type: :admin) }
    let(:context) { { user: user } }
    let(:account_policy) { described_class.new(account, context) }

    shared_examples_for 'authorized admin user' do
      it 'returns true when user is admin' do
        is_expected.to be_truthy
      end
    end

    describe '#index' do
      subject { account_policy.apply(:index?) }

      include_examples 'authorized admin user'
    end

    describe '#show' do
      subject { account_policy.apply(:show?) }

      include_examples 'authorized admin user'
    end

    describe '#create' do
      subject { account_policy.apply(:create?) }

      include_examples 'authorized admin user'
    end

    describe '#update' do
      subject { account_policy.apply(:update?) }

      include_examples 'authorized admin user'
    end

    describe '#destroy' do
      subject { account_policy.apply(:destroy?) }

      include_examples 'authorized admin user'
    end
  end

  context 'when user is super' do
    let(:account) { AccountFactory.create }
    let(:user) { UserFactory.create(password: 'password', user_type: :super) }
    let(:context) { { user: user } }
    let(:account_policy) { described_class.new(account, context) }

    shared_examples_for 'authorized super user' do
      it 'returns true when user is super' do
        is_expected.to be_truthy
      end
    end

    describe '#index' do
      subject { account_policy.apply(:index?) }

      include_examples 'authorized super user'
    end

    describe '#show' do
      subject { account_policy.apply(:show?) }

      include_examples 'authorized super user'
    end

    describe '#create' do
      subject { account_policy.apply(:create?) }

      include_examples 'authorized super user'
    end

    describe '#update' do
      subject { account_policy.apply(:update?) }

      include_examples 'authorized super user'
    end

    describe '#destroy' do
      subject { account_policy.apply(:destroy?) }

      include_examples 'authorized super user'
    end
  end
end
