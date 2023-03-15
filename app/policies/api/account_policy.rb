class Api::AccountPolicy < ApplicationPolicy
  def index?
    admin? || super?
  end

  def show?
    true
  end

  def create?
    true
  end

  def update?
    true
  end

  def destroy?
    true
  end
end