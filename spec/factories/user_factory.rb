require 'faker'

class UserFactory < BaseFactory
  def self.described_class
    User
  end

  private

  def options(params)
    {
      email: params.fetch(:email, Faker::Internet.email),
      password: params[:password],
      user_type: params.fetch(:user_type, :standard)
    }
  end
end