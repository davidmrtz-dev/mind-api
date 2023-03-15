class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable

  include DeviseTokenAuth::Concerns::User

  has_one :profile, dependent: :destroy
  has_many :user_teams
  has_many :teams, through: :user_teams

  enum user_type: { standard: 0, admin: 1, super: 2 }, _default: :standard

  accepts_nested_attributes_for :profile

  default_scope -> { where.not(user_type: :super) }
end
