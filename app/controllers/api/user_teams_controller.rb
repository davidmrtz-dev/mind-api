module Api
  class UserTeamsController < ApiController
    include Pagination

    before_action :authenticate_user!

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
        render json: { user_team: user_team }, status: :created
      else
        render json: { errors: user_team.errors.full_messages }, status: :unprocessable_entity
      end
    end

    private

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
  end
end