class ActiveAdmin::PagePolicy < ApplicationPolicy
  def index?
    user.Admin? || user.Editor? || user.Viewer?
  end

  def show?
    user.Admin? || user.Editor? || user.Viewer?
  end

  def create?
    user.Admin?
  end

  def update?
    user.Admin? || user.Editor?
  end

  def destroy?
    user.Admin?
  end

  def edit?
    update?
  end

  class Scope < ApplicationPolicy::Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end
end
