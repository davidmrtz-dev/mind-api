module Api
  class AccountsSerializer
    def initialize(accounts)
      @accounts = accounts
    end

    def self.json(accounts)
      new(accounts).json
    end

    def json
      @accounts.map do |account|
        account.serializable_hash(
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
end
