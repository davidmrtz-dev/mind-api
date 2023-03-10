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
        user.serializable_hash(
          except: %i[
            created_at
            updated_at
          ]
        )
      end
    end
  end
end