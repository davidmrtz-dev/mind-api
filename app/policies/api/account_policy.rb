class Api::AccountPolicy < ApplicationPolicy
  def index?
    admin? || super?
  end

  def show?
    admin? || super?
  end

  def create?
    admin? || super?
  end

  def update?
    admin? || super?
  end

  def destroy?
    admin? || super?
  end
end
