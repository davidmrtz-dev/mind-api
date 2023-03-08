class User < ActiveRecord::Base
  devise :database_authenticatable, :recoverable

  include DeviseTokenAuth::Concerns::User
end
