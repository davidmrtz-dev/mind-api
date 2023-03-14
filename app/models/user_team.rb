class UserTeam < ApplicationRecord
  belongs_to :user
  belongs_to :team

  enum status: { active: 0, inactive: 1 }

  validates :status, presence: true
  validate :create_date_not_before_today

  private

  def create_date_not_before_today
    return if end_at.nil? || end_at > Time.zone.now

    errors.add(:base, 'End date cannot be before today')
  end
end
