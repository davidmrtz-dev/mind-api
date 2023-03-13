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

    def create
      account =
        Account.new(account_params)

      if account.save
        render json: { account: ::Api::AccountSerializer.json(account) }, status: :created
      else
        render json: { errors: account.errors.full_messages }, status: :unprocessable_entity
      end
    end

    private

    def find_account
      Account.find(params[:id])
    end

    def account_params
      params.require(:account).permit(
        :client_name,
        :manager_name,
        :name
      )
    end
  end
end