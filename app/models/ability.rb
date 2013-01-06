class Ability
  include CanCan::Ability

  def initialize(user)
    can :manage, FeedbackGroup, user_id: user.id
  end
end
