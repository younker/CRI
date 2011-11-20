# Define abilities for the passed in user here. For example:
#
#   user ||= User.new # guest user (not logged in)
#   if user.admin?
#     can :manage, :all
#   else
#     can :read, :all
#   end
#
# The first argument to `can` is the action you are giving the user permission to do.
# If you pass :manage it will apply to every action. Other common actions here are
# :read, :create, :update and :destroy.
#
# The second argument is the resource the user can perform the action on. If you pass
# :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
#
# The third argument is an optional hash of conditions to further filter the objects.
# For example, here the user can only update published articles.
#
#   can :update, Article, :published => true
#
# See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
class Ability
  include CanCan::Ability
  
  def initialize(user)
    user ||= User.new # guest user




    #------------------------ hack
    can :manage, :all
    #------------------------ hack




    # Everybody can read blogs and view board (team) members
    can :read, Blog
    can :read, Team::Member

    
    # anybody can manage the object if it is theirs
    can :manage, User, :id => user.id
    can :manage, Team::Member, :id => user.id
    
    if user.admin?
      can :manage, :all
    else
      if user.moderator?
        can :manage, Blog
        # can :manage, Member
      end
    
      if user.author?
        can :manage, Blog, :user_id => user.id
      end
    
      if user.guest?
        can :create, User
      end
    end

  end
end
