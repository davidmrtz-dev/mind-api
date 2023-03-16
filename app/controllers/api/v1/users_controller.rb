module Api
  module V1
    class UsersController < ApiController
      include Pagination

      before_action :authenticate_user!
      before_action :verify_access
      before_action :not_allow_self_destroy, only: [:destroy]

      def index
        users = User.where.not(id: current_user.id)

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
          :name,
          :email,
          :password,
          :password_confirmation,
          :user_type,
          profile_attributes: [
            :english_level,
            :technical_knowledge,
            :cv
          ]
        )
      end

      def verify_access
        authorize!
      end

      def not_allow_self_destroy
        raise Errors::SelfDestroy if find_user == current_user
      end
    end
  end
end