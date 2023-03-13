require 'faker'

class TeamFactory
  def self.create(params = {})
    Team.create!(
      account: params.fetch(:account),
      name: params.fetch(:name, Faker::Team.name)
    )
  end
end