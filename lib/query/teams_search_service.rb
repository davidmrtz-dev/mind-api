module Query
  class TeamSearchService < ApplicationService
    def initialize(user)
      @user = user
    end

    def process
      'results'
    end
  end
end