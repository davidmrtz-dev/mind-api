module Api
  class UserTeamSerializer
    def initialize(user_team)
      @user_team = user_team
    end

    def self.json(user_team)
      new(user_team).json
    end

    def json
      @user_team.serializable_hash(
        include: [
          :user,
          :team
        ],
        except: %i[
          created_at
          updated_at
        ]
      )
    end
  end
end