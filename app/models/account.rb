class Account < ApplicationRecord
  has_many :teams, dependent: :destroy

  validates :client_name, presence: true, on: :update
  validates :manager_name, presence: true, on: :update
  validates :name, presence: true, on: :update
end
