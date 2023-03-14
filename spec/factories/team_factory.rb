require 'faker'

class TeamFactory < BaseFactory
  def self.described_class
    Team
  end

  private

  def options(params)
    {
      account: params.fetch(:account),
      name: params.fetch(:name, Faker::Team.name)
    }
  end
end