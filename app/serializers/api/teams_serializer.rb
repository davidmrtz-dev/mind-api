module Api
  class TeamsSerializer
    def initialize(teams, user_id = nil)
      @teams = teams
      @user_id = user_id
    end

    def self.json(teams)
      new(teams).json
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

        return serialized.merge({ ok: 'ok' }) if @user_id.present?

        serialized
      end
    end
  end
end
