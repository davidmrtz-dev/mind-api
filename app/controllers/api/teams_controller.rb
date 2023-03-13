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

      render json: { team: ::Api::TeamSerializer.json(team) }
    end

    def create
      account = find_account
      team =
        Team.new(team_params.merge(account: account))

      if team.save
        render json: { team: ::Api::TeamSerializer.json(team) }, status: :created
      else
        render json: { errors: team.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def update
      team = find_team

      if team.update(team_params)
        render json: { team: ::Api::TeamSerializer.json(team) }
      else
        render json: { errors: team.errors.full_messages }, status: :unprocessable_entity
      end
    end

    private

    def find_team
      Team.find(params[:id])
    end

    def find_account
      Account.find(team_params[:account_id])
    end

    def team_params
      params.require(:team).permit(
        :account_id,
        :name
      )
    end
  end
end