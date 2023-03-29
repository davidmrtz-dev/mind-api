module Api
  class UsersSerializer
    def initialize(users)
      @users = users
    end

    def self.json(users)
      new(users).json
    end

    def json
      @users.map do |user|
        teams = user.teams.includes(:user_teams).map do |team|
          user_team = team.user_teams.find_by(user_id: user.id)
          team.as_json(except: %i[created_at updated_at]).merge(user_team: user_team.as_json(except: %i[created_at updated_at]))
        end

        {
          id: user.id,
          name: user.name,
          nickname: user.nickname,
          email: user.email,
          user_type: user.user_type,
          profile: user.profile.serializable_hash(
            except: %i[created_at updated_at]
          ),
          teams: teams
        }
      end
    end
  end
end
