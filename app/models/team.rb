class Team < ApplicationRecord
  belongs_to :account

  has_many :user_teams, dependent: :destroy
  has_many :users, through: :user_teams

  validates :name, presence: true

  default_scope -> { order(created_at: :desc) }
end
