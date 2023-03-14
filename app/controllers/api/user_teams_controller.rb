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
  end
end