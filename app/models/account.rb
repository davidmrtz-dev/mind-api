class Account < ApplicationRecord
  has_many :teams, dependent: :destroy
end
