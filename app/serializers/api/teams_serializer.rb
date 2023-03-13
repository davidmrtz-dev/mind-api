module Api
  class TeamsSerializer
    def initialize(teams)
      @teams = teams
    end

    def self.json(teams)
      new(teams).json
    end

    def json
      @teams.map do |team|
        team.serializable_hash(
          except: %i[
            created_at
            updated_at
          ]
        )
      end
    end
  end
end