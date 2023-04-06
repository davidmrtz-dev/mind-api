module Api
  class TeamsSerializer
    def initialize(teams, user_id)
      @teams = teams
      @user_id = user_id
    end

    def self.json(teams, user_id = nil)
      new(teams, user_id).json
    end

    def json
      @teams.map do |team|
        serialized = team.serializable_hash(
          include: [
            :account
          ],
          except: %i[
            created_at
            updated_at
          ]
        )

        if @user_id.present?
          user_team = team.user_teams.find_by(user_id: @user_id)
          serialized.merge!(user_team: user_team&.serializable_hash(
            except: %i[created_at updated_at]
          ))
        end

        serialized
      end
    end
  end
end
