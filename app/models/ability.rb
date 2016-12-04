class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user
    if user 
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities 
    end
  end

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer, Comment]
    can :update, [Question, Answer], user: user
    can :destroy, [Question, Answer], user: user
    can [:vote_up, :vote_down, :vote_cancel], [Question, Answer] { |votable| !user.belongs_to_obj(votable) }
    can :best, [Answer] { |answer| answer.user != user }
    can :destroy, [Attachment], attachable: { user: user }
    can [:index, :me], User
    can [:create, :destroy], Subscription
  end
end
