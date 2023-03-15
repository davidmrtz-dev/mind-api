class ApplicationPolicy < ActionPolicy::Base
  authorize :user, allow_nil: true

  private

  def standard?
    user.standard?
  end

  def admin?
    user.admin?
  end

  def super?
    user.super?
  end
end