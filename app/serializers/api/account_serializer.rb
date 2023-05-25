module Api
  class AccountSerializer
    def initialize(account)
      @account = account
    end

    def self.json(account)
      new(account).json
    end

    def json
      @account.serializable_hash(
        include: [
          :teams
        ],
        except: %i[
          created_at
          updated_at
        ]
      )
    end
  end
end
