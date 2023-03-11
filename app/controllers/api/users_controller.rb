module Api
  class UsersController < ApiController
    include Pagination

    before_action :authenticate_user!

    def index
      users = User.all

      page = paginate(
        users,
        limit: params[:limit],
        offset: params[:offset]
      )

      render json: {
        users: ::Api::UsersSerializer.json(page)
      }
    end

    def show
      user = find_user

      render json: { user: user }
    end

    private

    def find_user
      User.find(params[:id])
    end
  end
end