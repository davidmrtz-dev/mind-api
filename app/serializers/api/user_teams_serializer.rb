module Api
  class UserTeamsSerializer
    def initialize(user_teams)
      @user_teams = user_teams
    end

    def self.json(user_teams)
      new(user_teams).json
    end

    def json
      @user_teams.map do |user_team|
        user_team.serializable_hash(
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
end