module Api
  module V1
    class UserTeamsController < ApiController
      include Pagination

      before_action :authenticate_user!
      before_action :verify_access

      def index
        user_teams = UserTeam.all

        page = paginate(
          user_teams,
          limit: params[:limit],
          offset: params[:offset]
        )

        render json: {
          user_teams: ::Api::UserTeamsSerializer.json(page)
        }
      end

      def create
        user = find_user
        team = find_team

        user_team =
          UserTeam.new(user_team_params.merge(user: user, team: team))

        if user_team.save
          render json: { user_team: ::Api::UserTeamSerializer.json(user_team) }, status: :created
        else
          render json: { errors: user_team.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        find_user_team.destroy!

        head :no_content
      end

      private

      def find_user_team
        UserTeam.find(params[:id])
      end

      def find_user
        User.find(user_team_params[:user_id])
      end

      def find_team
        Team.find(user_team_params[:team_id])
      end

      def user_team_params
        params.require(:user_team).permit(
          :user_id,
          :team_id,
          :start_at,
          :end_at,
          :status
        )
      end

      def verify_access
        authorize!
      end
    end
  end
end