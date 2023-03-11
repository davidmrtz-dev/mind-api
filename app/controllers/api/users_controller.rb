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

    def create
      user =
        User.new(user_params)

      if user.save
        render json: { user: user }, status: :created
      else
        render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
      end
    end

    private

    def find_user
      User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(
        :email,
        :password,
        :password_confirmation
      )
    end
  end
end