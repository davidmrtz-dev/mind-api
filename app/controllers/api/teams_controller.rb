module Api
  class TeamsController < ApiController
    include Pagination

    before_action :authenticate_user!

    def index
      teams = Team.all

      page = paginate(
        teams,
        limit: params[:limit],
        offset: params[:offset]
      )

      render json: {
        teams: page
      }
    end
  end
end