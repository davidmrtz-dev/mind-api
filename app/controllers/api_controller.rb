class ApiController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  include ActionPolicy::Controller

  authorize :user, through: :current_user
end
