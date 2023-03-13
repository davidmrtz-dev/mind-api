require 'faker'

class AccountFactory
  def self.create(params = {})
    Account.create!(
      client_name: params.fetch(:client_name, Faker::Name.name),
      manager_name: params.fetch(:manager_name, Faker::Name.name),
      name: params.fetch(:name, Faker::Team.name)
    )
  end
end