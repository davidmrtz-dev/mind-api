module Api
  class UserSerializer
    def initialize(user)
      @user = user
    end

    def self.json(user)
      new(user).json
    end

    def json
      @user.serializable_hash(
        include: [
          :profile
        ],
        except: %i[
          created_at
          updated_at
        ]
      )
    end
  end
end