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
          include: %i[
            profile
          ],
          except: %i[
            provider
            uid
            allow_password_change
            nickname
            image
            created_at
            updated_at
          ]
        )
      end
    end
  end
end
