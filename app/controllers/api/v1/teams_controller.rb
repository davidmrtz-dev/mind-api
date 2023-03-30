module Api
  module V1
    class TeamsController < ApiController
      include Pagination

      before_action :authenticate_user!
      before_action :authorize!

      def index
        if params[:user_id].present?
          user = find_user
          teams = Team.where.not(id: user.team_ids)
        else
          teams = Team.all
        end



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
        teams = teams(find_user)

        render json: { teams: teams }
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

      def destroy
        find_team.destroy!

        head :no_content
      end

      private

      def find_team
        Team.find(params[:id])
      end

      def find_user
        User.find(params[:user_id])
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

      def teams(user)
        user.teams.includes(:user_teams).limit(params[:limit] || 10).offset(params[:offset] || 0).map do |team|
          user_team = team.user_teams.find_by(user_id: user.id)
          team.as_json(except: %i[created_at
                                  updated_at]).merge(user_team: user_team.as_json(except: %i[created_at updated_at]))
        end
      end
    end
  end
end
