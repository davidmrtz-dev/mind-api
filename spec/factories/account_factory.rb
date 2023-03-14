require 'faker'

class AccountFactory < BaseFactory
  def self.described_class
    Account
  end

  private

  def options(params)
    {
      client_name: params.fetch(:client_name, Faker::Name.name),
      manager_name: params.fetch(:manager_name, Faker::Name.name),
      name: params.fetch(:name, Faker::Team.name)
    }
  end
end