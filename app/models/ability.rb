class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.role? :admin
        can :manage, :all
    elsif user.role? :manager
        can :read, Store
        can :read, Job
        can :read, Flavor

        can :read, Employee do |this_employee|
            my_store = user.current_assignment.store_id
            my_store == this_employee.current_assignment.store_id
        end

        can :read, Shift do |this_shift|
            my_store = user.current_assignment.store_id
            my_store == this_shift.store.id
        end

        can :create, Shift do |this_shift|
            my_store = user.current_assignment.store_id
            my_store == this_shift.store.id && my_store == this_shift.employee.current_assignment.store_id
        end

        can :update, Shift do |this_shift|
            my_store = user.current_assignment.store_id
            my_store == this_shift.store.id
        end

        can :destroy, Shift do |this_shift|
            my_store = user.current_assignment.store_id
            my_store == this_shift.store.id
        end

        can :create, ShiftJob do |this_shift_job|
            my_store = user.current_assignment.store_id
            my_store == this_shift_job.shift.store.id
        end

        can :destroy, ShiftJob do |this_shift_job|
            my_store = user.current_assignment.store_id
            my_store == this_shift_job.shift.store.id
        end

        can :create, StoreFlavor do |this_store_flavor|
            my_store = user.current_assignment.store_id
            my_store == this_store_flavor.store.id
        end

        can :destroy, StoreFlavor do |this_store_flavor|
            my_store = user.current_assignment.store_id
            my_store == this_store_flavor.store.id
        end

    elsif user.role? :employee
        can :read, Store
        can :read, Job
        can :read, Flavor

        can :read, Employee do |this_employee|
            this_employee.id == user.employee_id
        end

        can :read, User do |u|
            u.id == user.id
        end

        can :index, Assignment do |this_assignment|
            this_assignment.employee_id == user.employee_id
        end

        can :read, Assignment do |this_assignment|
            this_assignment.employee_id == user.employee_id
        end

        can :read, Shift do |this_shift|
            this_shift.employee.id == user.employee_id
        end

        can :read, ShiftJob do |this_shift_job|
            this_shift_job.shift.employee.id == user.employee_id
        end

        can :update, Employee do |this_employee|
            this_employee.id == user.employee_id
        end

        can :read, User do |u|
            u.id == user.id
        end
    else
        can :read, Store
        can :read, StoreFlavor
    end

    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end
end
