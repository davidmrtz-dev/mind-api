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

      render json: { user: ::Api::UserSerializer.json(user) }
    end

    def create
      user =
        User.new(user_params)

      if user.save
        render json: { user: ::Api::UserSerializer.json(user) }, status: :created
      else
        render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def update
      user = find_user

      if user.update(user_params)
        render json: { user: ::Api::UserSerializer.json(user) }
      else
        render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def destroy
      find_user.destroy!

      head :no_content
    end

    private

    def find_user
      User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(
        :email,
        :password,
        :password_confirmation,
        :nickname
      )
    end
  end
end