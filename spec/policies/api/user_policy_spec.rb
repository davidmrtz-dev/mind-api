require 'rails_helper'

RSpec.describe Api::UserPolicy, type: :policy do
  context 'when user is standard' do
    let(:user) { UserFactory.create(password: 'password') }
    let(:other_user) { UserFactory.create(password: 'password') }
    let(:context) { { user: other_user } }
    let(:user_policy) { described_class.new(user, context) }

    shared_examples_for 'not authorized standard user' do
      it 'returns false when user is standard' do
        is_expected.to be_falsey
      end
    end

    describe '#index?' do
      subject { user_policy.apply(:index?) }

      include_examples 'not authorized standard user'
    end

    describe '#show?' do
      subject { user_policy.apply(:show?) }

      it 'returns true' do
        is_expected.to be_truthy
      end
    end

    describe '#create?' do
      subject { user_policy.apply(:create?) }

      include_examples 'not authorized standard user'
    end

    describe '#udpate?' do
      subject { user_policy.apply(:update?) }

      include_examples 'not authorized standard user'
    end

    describe '#destroy?' do
      subject { user_policy.apply(:destroy?) }

      include_examples 'not authorized standard user'
    end
  end

  context 'when user is admin' do
    let(:user) { UserFactory.create(password: 'password') }
    let(:admin_user) { UserFactory.create(password: 'password', user_type: :admin) }
    let(:context) { { user: admin_user } }
    let(:user_policy) { described_class.new(user, context) }

    shared_examples_for 'authorized admin user' do
      it 'returns true when user is admin' do
        is_expected.to be_truthy
      end
    end

    describe '#index' do
      subject { user_policy.apply(:index?) }

      include_examples 'authorized admin user'
    end

    describe '#show' do
      subject { user_policy.apply(:show?) }

      include_examples 'authorized admin user'
    end

    describe '#create' do
      subject { user_policy.apply(:create?) }

      include_examples 'authorized admin user'
    end

    describe '#update' do
      subject { user_policy.apply(:update?) }

      include_examples 'authorized admin user'
    end

    describe '#destroy' do
      subject { user_policy.apply(:destroy?) }

      include_examples 'authorized admin user'
    end
  end

  context 'when user is super' do
    let(:user) { UserFactory.create(password: 'password') }
    let(:super_user) { UserFactory.create(password: 'password', user_type: :super) }
    let(:context) { { user: super_user } }
    let(:user_policy) { described_class.new(user, context) }

    shared_examples_for 'authorized super user' do
      it 'returns true when user is super' do
        is_expected.to be_truthy
      end
    end

    describe '#index' do
      subject { user_policy.apply(:index?) }

      include_examples 'authorized super user'
    end

    describe '#show' do
      subject { user_policy.apply(:show?) }

      include_examples 'authorized super user'
    end

    describe '#create' do
      subject { user_policy.apply(:create?) }

      include_examples 'authorized super user'
    end

    describe '#update' do
      subject { user_policy.apply(:update?) }

      include_examples 'authorized super user'
    end

    describe '#destroy' do
      subject { user_policy.apply(:destroy?) }

      include_examples 'authorized super user'
    end
  end
end