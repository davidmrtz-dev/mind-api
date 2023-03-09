class Team < ApplicationRecord
  belongs_to :account

  validates :name, presence: true, on: :update
end
