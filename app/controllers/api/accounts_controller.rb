module Api
  class AccountsController < ApiController
    include Pagination

    before_action :authenticate_user!

    def index
      accounts = Account.all

      page = paginate(
        accounts,
        limit: params[:limit],
        offset: params[:offset]
      )

      render json: {
        accounts: ::Api::AccountsSerializer.json(page)
      }
    end

    def show
      account = find_account

      render json: { account: ::Api::AccountSerializer.json(account) }
    end

    private

    def find_account
      Account.find(params[:id])
    end
  end
end