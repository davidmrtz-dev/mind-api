module Api
  class TeamSerializer
    def initialize(team)
      @team = team
    end

    def self.json(team)
      new(team).json
    end

    def json
      @team.serializable_hash(
        except: %i[
          created_at
          updated_at
        ]
      )
    end
  end
end