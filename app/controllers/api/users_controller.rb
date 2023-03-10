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
        users: page
      }
    end
  end
end