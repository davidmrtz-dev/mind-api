class Profile < ApplicationRecord
  belongs_to :user

  enum english_level: { a1: 0, a2: 1, b1: 2, b2: 3, c1: 4, c2: 5 }

  validates :english_level, presence: true
  validates :technical_knowledge, presence: true
end
