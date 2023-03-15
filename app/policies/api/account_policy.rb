class Api::AccountPolicy < ApplicationPolicy
  def index
    admin? || super?
  end
end