# frozen_string_literal: true

# CanCanCan Ability class is used to define user permissions.
# For instance: event organizers can manage event items, but customers can only read them.

# Customers are only allowed to do actions defined in defined_customer_abilities method
# Event organizers are only allowed to do actions defined in defined_event_organizer_abilities method

# See the CanCanCan documentation for more information:
# https://github.com/ryanb/cancan/wiki/Defining-Abilities

# NOTE: :manage == all CRUD operations (INCLUDING :custom_actions)
class Ability
  include CanCan::Ability

  def initialize(user)
    @user = user || User.new

    alias_action :create, :read, :update, :destroy, to: :crud
    alias_action :create, :read, :destroy, to: :crd
    alias_action :create, :read, :update, to: :cru
    alias_action :read, :update, :destroy, to: :rud
    alias_action :read, :update, to: :ru

    define_customer_abilities if @user.customer?
    define_event_organizer_abilities if @user.event_organizer?
  end

  private

  def define_customer_abilities
    can :read, EventItem
    can :read, EventItem, status: %i[published sold_out completed cancelled]
    cannot :create, EventItem
    cannot :destroy, EventItem
    cannot :update, EventItem
    can :create, Purchase
  end

  def define_event_organizer_abilities
    can :manage, EventItem, event_organizer_id: @user.event_organizer.id
  end
end
