module Api
  class UsersController < ApiController
    before_action :authenticate_user!

    def index
      head :ok
    end
  end
end