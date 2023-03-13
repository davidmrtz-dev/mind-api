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
        teams: ::Api::TeamsSerializer.json(page)
      }
    end

    def show
      team = find_team

      render json: { team: team }
    end

    private

    def find_team
      Team.find(params[:id])
    end
  end
end