class UserTeam < ApplicationRecord
  belongs_to :user
  belongs_to :team

  enum status: { active: 0, inactive: 1 }

  validates :status, presence: true
end
