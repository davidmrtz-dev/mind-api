module Query
  class TeamSearchService < ApplicationService
    def initialize(user)
      @user = user
    end

    def process
      'return results'
    end
  end
end