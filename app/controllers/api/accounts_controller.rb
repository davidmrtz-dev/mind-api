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
        accounts: page
      }
    end
  end
end