# frozen_string_literal: true

class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    user.Admin? || user.Editor? || user.Viewer? # Example: Allow admins and editors to view the index
  end

  def show?
    user.Admin? || user.Editor? || user.Viewer?
  end

  def create?
    user.Admin?
  end

  def new?
    user.Admin?
  end

  def update?
    user.Admin? || user.Editor?
  end

  def edit?
    user.Admin?
  end

  def destroy?
    user.Admin?
  end

  class Scope
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      raise NoMethodError, "You must define #resolve in #{self.class}"
    end

    private

    attr_reader :user, :scope
  end
end
