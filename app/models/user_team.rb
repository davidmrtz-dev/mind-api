class UserTeam < ApplicationRecord
  belongs_to :user
  belongs_to :team

  enum status: { active: 0, inactive: 1 }

  validates :status, presence: true
  validates :start_at, presence: true
  validates :end_at, presence: true
  validate :end_at_not_before_today, on: [:create]

  default_scope -> { order(created_at: :desc) }

  private

  def end_at_not_before_today
    return if end_at.nil? || end_at > Time.zone.now

    errors.add(:base, 'End date cannot be before today')
  end
end
