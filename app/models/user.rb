class User < ApplicationRecord
  devise :database_authenticatable, :registerable

  include DeviseTokenAuth::Concerns::User

  has_one :profile, dependent: :destroy
  has_many :user_teams, dependent: :destroy
  has_many :teams, through: :user_teams

  enum user_type: { standard: 0, admin: 1, super: 2 }

  validates :name, presence: true
  validates :user_type, presence: true

  accepts_nested_attributes_for :profile

  default_scope -> { where.not(user_type: :super).order(created_at: :desc) }
end
