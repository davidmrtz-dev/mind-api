class Account < ApplicationRecord
  has_many :teams, dependent: :destroy

  validates :client_name, presence: true
  validates :manager_name, presence: true
  validates :name, presence: true

  default_scope -> { order(created_at: :desc) }
end
