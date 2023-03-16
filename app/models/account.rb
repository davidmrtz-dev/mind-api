class Account < ApplicationRecord
  has_many :teams, dependent: :destroy

  validates :name, presence: true

  default_scope -> { order(created_at: :desc) }
end
